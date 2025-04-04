prompt --workspace/credentials/keycloak
begin
--   Manifest
--     CREDENTIAL: keycloak
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(85476629738434870)
,p_name=>'keycloak'
,p_static_id=>'ords_t'
,p_authentication_type=>'BASIC'
,p_prompt_on_install=>true
);
wwv_flow_imp.component_end;
end;
/
