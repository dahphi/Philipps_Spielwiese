prompt --application/shared_components/user_interface/lovs/loeschgruende
begin
--   Manifest
--     LOESCHGRUENDE
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
 p_id=>wwv_flow_imp.id(37527876153353916)
,p_lov_name=>'LOESCHGRUENDE'
,p_lov_query=>'.'||wwv_flow_imp.id(37527876153353916)||'.'
,p_location=>'STATIC'
,p_version_scn=>4095585374794
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(37528105553353922)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Projekt fertiggestellt'
,p_lov_return_value=>'1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(37528534698353924)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>unistr('Projekt zur\00FCckgezogen')
,p_lov_return_value=>'2'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(37528939519353924)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Test'
,p_lov_return_value=>'3'
);
wwv_flow_imp.component_end;
end;
/
