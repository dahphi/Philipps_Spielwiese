#!/usr/bin/env node

const fs = require('fs');
const os = require('os');
const path = require('path');
const https = require('https');

function parseArgs(argv) {
  const args = { dryRun: false };
  for (let i = 2; i < argv.length; i += 1) {
    const a = argv[i];
    if (a === '--dry-run') args.dryRun = true;
    else if (a === '--date') args.date = argv[++i];
    else if (a === '--settings') args.settings = argv[++i];
  }
  return args;
}

function readJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function pickSettingsPath(explicit) {
  const candidates = [];
  if (explicit) candidates.push(explicit);
  if (process.env.VSCODE_SETTINGS_PATH) candidates.push(process.env.VSCODE_SETTINGS_PATH);
  candidates.push(path.join(os.homedir(), 'Library/Application Support/Code/User/profiles/7ddec8de/settings.json'));
  candidates.push(path.join(os.homedir(), 'Library/Application Support/Code/User/settings.json'));
  candidates.push(path.join(process.cwd(), '.vscode/settings.json'));

  for (const p of candidates) {
    if (p && fs.existsSync(p)) return p;
  }

  throw new Error('No settings.json found. Pass --settings <path> or set VSCODE_SETTINGS_PATH.');
}

function requestJson({ baseUrl, token, method, apiPath, body }) {
  const url = new URL(apiPath, baseUrl);
  const payload = body ? JSON.stringify(body) : null;

  const options = {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json'
    }
  };

  if (payload) {
    options.headers['Content-Type'] = 'application/json';
    options.headers['Content-Length'] = Buffer.byteLength(payload);
  }

  return new Promise((resolve, reject) => {
    const req = https.request(url, options, (res) => {
      let raw = '';
      res.setEncoding('utf8');
      res.on('data', (chunk) => {
        raw += chunk;
      });
      res.on('end', () => {
        let parsed;
        try {
          parsed = raw ? JSON.parse(raw) : {};
        } catch {
          return reject(new Error(`Invalid JSON response (${res.statusCode}): ${raw.slice(0, 500)}`));
        }

        if (res.statusCode < 200 || res.statusCode >= 300) {
          const msg = parsed?.message || parsed?.statusMessage || JSON.stringify(parsed).slice(0, 500);
          return reject(new Error(`HTTP ${res.statusCode}: ${msg}`));
        }

        resolve(parsed);
      });
    });

    req.on('error', reject);
    if (payload) req.write(payload);
    req.end();
  });
}

function parseTitleDate(title) {
  const m = /^(\d{4}-\d{2}-\d{2})\s+Meeting notes$/i.exec(title || '');
  return m ? m[1] : null;
}

function addDays(isoDate, days) {
  const d = new Date(`${isoDate}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}

function toDottedDate(isoDate) {
  const [y, m, d] = isoDate.split('-');
  return `${d}.${m}.${y}`;
}

function replaceDatesInBody(body, targetIsoDate) {
  const targetDotted = toDottedDate(targetIsoDate);

  return body
    .replace(/\d{4}-\d{2}-\d{2}(?=\s*Meeting notes)/gi, targetIsoDate)
    .replace(/\b\d{4}-\d{2}-\d{2}\b/g, targetIsoDate)
    .replace(/\b\d{2}\.\d{2}\.\d{4}\b/g, targetDotted)
    .replace(/(<time[^>]*datetime=")\d{4}-\d{2}-\d{2}(")/gi, `$1${targetIsoDate}$2`);
}

async function findLastMeetingPage(cfg) {
  let start = 0;
  const limit = 100;
  const pages = [];

  while (true) {
    const out = await requestJson({
      ...cfg,
      method: 'GET',
      apiPath: `/rest/api/content/${cfg.parentId}/child/page?limit=${limit}&start=${start}`
    });

    const batch = out.results || [];
    pages.push(...batch);
    if (batch.length < limit) break;
    start += limit;
  }

  const dated = pages
    .map((p) => ({ page: p, date: parseTitleDate(p.title) }))
    .filter((x) => !!x.date)
    .sort((a, b) => a.date.localeCompare(b.date));

  if (dated.length === 0) {
    throw new Error('No existing dated meeting notes found under parent.');
  }

  return dated[dated.length - 1];
}

async function main() {
  const args = parseArgs(process.argv);
  const settingsPath = pickSettingsPath(args.settings);
  const settings = readJson(settingsPath);
  const s = settings.setup_secrets || {};

  const baseUrl = (s['confluence.api.baseUrl'] || '').replace(/\/$/, '');
  const token = s['confluence.api.token'];
  const spaceKey = s['confluence.defaults.spaceKey'] || 'SPD';
  const parentId = s['confluence.defaults.meetingNotesParentId'] || '429698593';

  if (!baseUrl || !token) {
    throw new Error('Missing confluence.api.baseUrl or confluence.api.token in setup_secrets.');
  }

  const cfg = { baseUrl, token, parentId };

  const last = await findLastMeetingPage(cfg);
  const sourcePage = await requestJson({
    ...cfg,
    method: 'GET',
    apiPath: `/rest/api/content/${last.page.id}?expand=body.storage,title,space,ancestors`
  });

  const targetDate = args.date || addDays(last.date, 7);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(targetDate)) {
    throw new Error('Invalid --date format. Use YYYY-MM-DD.');
  }

  const newTitle = `${targetDate} Meeting notes`;
  const newBody = replaceDatesInBody(sourcePage.body?.storage?.value || '', targetDate);

  if (args.dryRun) {
    console.log(`Source: ${sourcePage.title} (${last.page.id})`);
    console.log(`Target: ${newTitle}`);
    console.log(`${baseUrl}/spaces/${spaceKey}/pages/(new-page-id)/${encodeURIComponent(newTitle.replace(/ /g, '+'))}`);
    return;
  }

  const created = await requestJson({
    ...cfg,
    method: 'POST',
    apiPath: '/rest/api/content',
    body: {
      type: 'page',
      title: newTitle,
      space: { key: spaceKey },
      ancestors: [{ id: String(parentId) }],
      body: { storage: { value: newBody, representation: 'storage' } }
    }
  });

  const url = `${baseUrl}/spaces/${spaceKey}/pages/${created.id}/${encodeURIComponent(newTitle.replace(/ /g, '+'))}`;
  console.log(newTitle);
  console.log(url);
}

main().catch((err) => {
  console.error(err.message || String(err));
  process.exit(1);
});
