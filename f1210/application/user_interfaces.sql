prompt --application/user_interfaces
begin
--   Manifest
--     USER INTERFACES: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_user_interface(
 p_id=>wwv_flow_imp.id(1210)
,p_theme_id=>42
,p_home_url=>'f?p=&APP_ID.:1:&SESSION.'
,p_login_url=>'f?p=&APP_ID.:LOGIN:&APP_SESSION.::&DEBUG.:::'
,p_theme_style_by_user_pref=>false
,p_built_with_love=>false
,p_global_page_id=>0
,p_navigation_list_id=>wwv_flow_imp.id(236499903583961930)
,p_navigation_list_position=>'TOP'
,p_navigation_list_template_id=>wwv_flow_imp.id(236613371930961980)
,p_nav_list_template_options=>'#DEFAULT#:js-tabLike'
,p_css_file_urls=>'#APP_IMAGES#app-icon.css?version=#APP_VERSION#'
,p_nav_bar_type=>'LIST'
,p_nav_bar_list_id=>wwv_flow_imp.id(236646341304961994)
,p_nav_bar_list_template_id=>wwv_flow_imp.id(236609545638961977)
,p_nav_bar_template_options=>'#DEFAULT#'
);
wwv_flow_imp.component_end;
end;
/
