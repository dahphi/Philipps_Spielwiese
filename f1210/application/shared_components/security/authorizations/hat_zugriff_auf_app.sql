prompt --application/shared_components/security/authorizations/hat_zugriff_auf_app
begin
--   Manifest
--     SECURITY SCHEME: hat Zugriff auf App
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(238022332535849873)
,p_name=>'hat Zugriff auf App'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN PCK_APEX_AUTH.FB_IS_MEMBER(:APP_USER, ''AccApp Vermarktungscluster'');'
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Sie sind nicht berechtigt die Applikation Vermarktungscluster zu benutzen!',
'<br>Mehr Informationen:',
'<br>Siehe <a href="https://netwelt.netcologne.intern/display/APEX/Vermarktungscluster" target="_blank">Berechtigung</a>.',
'<br>'))
,p_version_scn=>1
,p_caching=>'BY_USER_BY_SESSION'
,p_comments=>wwv_flow_string.join(wwv_flow_t_varchar2(
'2022-04-21 war:',
'SELECT 1',
'FROM (',
'SELECT NAME,dn,val, SUBSTR(replace(val, ''CN='', NULL),1,INSTR(val,'','')-4) grp',
'  FROM table(apex_ldap.search (',
'           p_host            => ''ad.netcologne.intern'',',
'         p_username        => ''CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern'',',
'         p_pass            => ''ZMORj3Pw'',',
'           p_search_base     => ''OU=Abteilungen,DC=netcologne,DC=intern'',',
'           p_search_filter   => ''sAMAccountName=''||apex_escape.ldap_search_filter(:APP_USER),',
'           p_attribute_names => ''memberof'' ))',
')',
'WHERE grp = ''AccApp Vermarktungscluster'''))
);
wwv_flow_imp.component_end;
end;
/
