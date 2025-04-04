prompt --application/shared_components/user_interface/lovs/ausbaustatus
begin
--   Manifest
--     AUSBAUSTATUS
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
 p_id=>wwv_flow_imp.id(188589523509963882)
,p_lov_name=>'AUSBAUSTATUS'
,p_lov_query=>'SELECT disp_val, ret_val FROM core.v_lov_ausbaustatus'
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_use_local_sync_table=>false
,p_query_owner=>'AQ_MAIN'
,p_return_column_name=>'RET_VAL'
,p_display_column_name=>'DISP_VAL'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'DISP_VAL'
,p_default_sort_direction=>'ASC'
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
