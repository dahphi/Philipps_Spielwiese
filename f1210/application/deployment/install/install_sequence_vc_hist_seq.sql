prompt --application/deployment/install/install_sequence_vc_hist_seq
begin
--   Manifest
--     INSTALL: INSTALL-Sequence: VC_HIST_SEQ
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_install_script(
 p_id=>wwv_flow_imp.id(90315680135706805)
,p_install_id=>wwv_flow_imp.id(188324513986339742)
,p_name=>'Sequence: VC_HIST_SEQ'
,p_sequence=>20
,p_script_type=>'INSTALL'
,p_condition_type=>'NOT_EXISTS'
,p_condition=>'SELECT 1 FROM USER_SEQUENCES WHERE SEQUENCE_NAME = ''VC_HIST_SEQ'''
,p_script_clob=>'   CREATE SEQUENCE  "VC_HIST_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 NOCACHE NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ; '
);
wwv_flow_imp_shared.create_install_object(
 p_id=>wwv_flow_imp.id(90315761349706805)
,p_script_id=>wwv_flow_imp.id(90315680135706805)
,p_object_owner=>'#OWNER#'
,p_object_type=>'SEQUENCE'
,p_object_name=>'VC_HIST_SEQ'
);
wwv_flow_imp.component_end;
end;
/
