prompt --application/shared_components/security/authentications/keycloak
begin
--   Manifest
--     AUTHENTICATION: keycloak
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(41925268616821064)
,p_name=>'keycloak'
,p_scheme_type=>'NATIVE_SOCIAL'
,p_attribute_01=>wwv_flow_imp.id(85476629738434870)
,p_attribute_02=>'OPENID_CONNECT'
,p_attribute_03=>'https://keycloak.it-test.nc.de/realms/ords/.well-known/openid-configuration'
,p_attribute_07=>'email,profile'
,p_attribute_09=>'preferred_username'
,p_attribute_11=>'N'
,p_attribute_13=>'N'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_reference_id=>41695736472352642
,p_version_scn=>4100233264408
);
wwv_flow_imp.component_end;
end;
/
