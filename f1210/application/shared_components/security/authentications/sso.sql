prompt --application/shared_components/security/authentications/sso
begin
--   Manifest
--     AUTHENTICATION: SSO
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
 p_id=>wwv_flow_imp.id(236690633036971975)
,p_name=>'SSO'
,p_scheme_type=>'NATIVE_HTTP_HEADER_VARIABLE'
,p_attribute_01=>'SSOUSER'
,p_attribute_02=>'BUILTIN_URL'
,p_attribute_06=>'ALWAYS'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
