prompt --application/shared_components/user_interface/shortcuts/js_is_valid_url
begin
--   Manifest
--     SHORTCUT: JS_IS_VALID_URL
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_shortcut(
 p_id=>wwv_flow_imp.id(203013224053440565)
,p_shortcut_name=>'JS_IS_VALID_URL'
,p_shortcut_type=>'HTML_TEXT'
,p_reference_id=>38096551870331734
,p_comments=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('2022-05-11 @WISAND: Funktion zur syntaktischen \00DCberpr\00FCfung von Benutzereingaben. Kann als Validierungsfunktion f\00FCr Items verwendet werden. Einbinden in die APEX-Seite per Shortcut-Aufl\00F6sung in einer JavaScript-Region (Beispiel: App "Vermarktungsclust')
||'er")',
'#url https://stackoverflow.com/questions/5717093/check-if-a-javascript-string-is-a-url'))
,p_shortcut=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function isValidURL(string) {',
'  let url;',
'  try {',
'    url = new URL(string);',
'  } catch (_) {',
'    return false;  ',
'  }',
'  return url.protocol === "http:" || url.protocol === "https:";',
'}'))
);
wwv_flow_imp.component_end;
end;
/
