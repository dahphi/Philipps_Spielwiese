prompt --application/shared_components/logic/application_processes/collection_p4_löschen
begin
--   Manifest
--     APPLICATION PROCESS: Collection P4 löschen
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
 p_id=>wwv_flow_imp.id(214657552194763279)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>unistr('Collection P4 l\00F6schen')
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF APEX_COLLECTION.COLLECTION_EXISTS(''P4_CHECKBOX'') THEN',
'  APEX_COLLECTION.DELETE_COLLECTION (''P4_CHECKBOX'');',
'END IF;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'4'
,p_process_when_type=>'CURRENT_PAGE_NOT_EQUAL_CONDITION'
,p_process_comment=>unistr('Wenn irgendeine andere Seite als P4 aufgerufen wird, muss die Collection mit den gespeicherten Checkboxen gel\00F6scht werden. So erspart man sich das L\00F6schen durch \00DCberwachung s\00E4mtlicher Zugangswege (Buttons, Link-URLs etc.)')
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
