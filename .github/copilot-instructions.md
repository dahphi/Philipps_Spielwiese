# Confluence automation defaults (workspace)

Use these rules when a task mentions Confluence pages, meeting notes, copy/clone page, or move page.

## Connection defaults

- Base URL: `https://netwelt.netcologne.intern/`
- Read auth token from `.vscode/settings.json` key `confluence.api.token`.
- Never print the token in chat output.

## SPD APEX/PLSQL meeting-notes defaults

- Space key: `SPD`
- Meeting-notes parent page ID: `429698593` (`SPD / Chapter / APEX/PLSQL / Meeting Notes`)
- Template/source page ID (default): `480904472`
- Meeting-note title convention: `YYYY-MM-DD Meeting notes`
- Keep existing section headings/body structure unless explicitly asked to change content.

## Standard workflow

1. Fetch source page with `expand=body.storage,ancestors,space,title`.
2. Create new page under ancestor `429698593`.
3. Set title to `YYYY-MM-DD Meeting notes` matching sibling naming.
4. Update date values in body only where requested (for example `<time datetime="...">`).
5. If page lands under wrong parent, fix by updating `ancestors` to `429698593`.
6. Return only the final page URL and title in the final response.

## Jira defaults (workspace)

Use these defaults when creating or editing Jira tickets unless I explicitly override them.

- Jira base URL: `https://jira.netcologne.intern/`
- Read auth token from `.vscode/settings.json` key `jira.api.token`.
- Project is always `Chapters` (`CHAP`, project id `11303`).
- Component is always `C0de F0rc3` (component id `14711`).
- Reference issue for schema checks: `CHAP-238`.
- Never print Jira or Confluence tokens in chat output.

## Jira ticket workflow

When I ask to create a Jira ticket and do not provide additional details:

1. Create the issue in project `CHAP`.
2. Use issue type `Story (Kapitel eines Buches)` (`10401`).
3. Assign component `C0de F0rc3` (`14711`).
4. Set the summary exactly to the title I provide.
5. Return only the created Jira key and URL.

## Jenkins defaults (workspace)

Use these defaults when I ask to run the APEX deployment pipeline.

- Jenkins base URL: `https://jenkins.netcologne.intern/`
- Pipeline URL: `https://jenkins.netcologne.intern/view/MISC/job/MISC-BUILD/job/mis-apexlab-operator/job/main/`
- Read Jenkins token from `.vscode/settings.json` key `jenkins.api.token`.
- Default branch is always `develop` unless I override it.

### Required inputs

- Application ID (`Apex_APP_ID`)
- Operation (`OPERATION`)
- Version (`Version`) when needed
- Branch (default `develop`)
- Target database (`Target_Databaase`)

### Automation workflow for full deployment

If I ask to automate the whole process with the provided params, run sequentially and wait for each run to finish before starting the next:

1. Run pipeline with `OPERATION=Export` and params `Target_Databaase`, `Apex_APP_ID`, `branch=develop` (or provided branch).
2. Run pipeline with `OPERATION=Release` and params `Target_Databaase`, `Apex_APP_ID`, `Version`, `branch`.
3. Run pipeline with `OPERATION=Import` and params `Target_Databaase` (import target), `Apex_APP_ID`, `Version`, `branch`.

Return build URLs and final status for each step.
