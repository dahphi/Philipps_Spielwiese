prompt --application/shared_components/user_interface/lovs/markierung_zeitspanne
begin
--   Manifest
--     MARKIERUNG_ZEITSPANNE
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
 p_id=>wwv_flow_imp.id(89829366741097953)
,p_lov_name=>'MARKIERUNG_ZEITSPANNE'
,p_lov_query=>'.'||wwv_flow_imp.id(89829366741097953)||'.'
,p_location=>'STATIC'
,p_version_scn=>4073930722047
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89829713209097963)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Letzter Tag'
,p_lov_return_value=>'1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89830083495097966)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Letzte 7 Tage'
,p_lov_return_value=>'7'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89830453619097966)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Letzte 30 Tage'
,p_lov_return_value=>'30'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89830874221097966)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Letzte 3 Monate'
,p_lov_return_value=>'90'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89831247556097966)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Letzte 6 Monate'
,p_lov_return_value=>'180'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(89831667514097966)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'Letztes Jahr'
,p_lov_return_value=>'360'
);
wwv_flow_imp.component_end;
end;
/
