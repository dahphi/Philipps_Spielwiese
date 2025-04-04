prompt --application/shared_components/user_interface/lovs/mandant
begin
--   Manifest
--     MANDANT
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
 p_id=>wwv_flow_imp.id(221081075093486933)
,p_lov_name=>'MANDANT'
,p_reference_id=>58865574415664170
,p_lov_query=>'.'||wwv_flow_imp.id(221081075093486933)||'.'
,p_location=>'STATIC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(221084570296531618)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'NetCologne'
,p_lov_return_value=>'NC'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(221084943551531618)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'NetAachen'
,p_lov_return_value=>'NA'
);
wwv_flow_imp.component_end;
end;
/
