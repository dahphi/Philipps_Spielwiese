prompt --application/shared_components/logic/application_processes/collections_erzeugen
begin
--   Manifest
--     APPLICATION PROCESS: COLLECTIONS_ERZEUGEN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_flow_process(
 p_id=>wwv_flow_imp.id(238053742340456373)
,p_process_sequence=>1
,p_process_point=>'ON_NEW_INSTANCE'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'COLLECTIONS_ERZEUGEN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin ',
'  apex_debug.enable(p_level => apex_debug.c_log_level_info); ',
'                    -- for more details, use: c_log_level_app_trace',
'  apex_debug.message(p_message => ''Debug enabled.'');',
unistr('APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(''ADRESSEN_NEU''); -- #deprecated, aber noch drinlassen bis Seite 7 durch Seite 4 (Collection ''P4_CHECKBOX'') abgel\00F6st ist'),
'end;'))
,p_process_clob_language=>'PLSQL'
,p_process_when_type=>'NEVER'
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
