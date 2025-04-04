prompt --application/shared_components/user_interface/lovs/wholebuy_partner
begin
--   Manifest
--     WHOLEBUY-PARTNER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(224540476061481522)
,p_lov_name=>'WHOLEBUY-PARTNER'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT singular AS D,',
'       key      AS R',
'  FROM enum',
' WHERE domain = ''WHOLEBUY_PARTNER''',
'   AND kontext = ''FTTH''',
'   AND sprache = ''*''',
' ORDER BY pos'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_owner=>'AQ_MAIN'
,p_return_column_name=>'R'
,p_display_column_name=>'D'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
