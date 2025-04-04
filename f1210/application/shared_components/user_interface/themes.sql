prompt --application/shared_components/user_interface/themes
begin
--   Manifest
--     THEME: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_theme(
 p_id=>wwv_flow_imp.id(236624940759961987)
,p_theme_id=>42
,p_theme_name=>'Universal Theme'
,p_theme_internal_name=>'UNIVERSAL_THEME'
,p_version_identifier=>'21.1'
,p_navigation_type=>'L'
,p_nav_bar_type=>'LIST'
,p_reference_id=>4070917134413059350
,p_is_locked=>false
,p_current_theme_style_id=>wwv_flow_imp.id(239582470054981818)
,p_default_page_template=>wwv_flow_imp.id(236506128449961933)
,p_default_dialog_template=>wwv_flow_imp.id(236510927631961935)
,p_error_template=>wwv_flow_imp.id(236508682288961934)
,p_printer_friendly_template=>wwv_flow_imp.id(236506128449961933)
,p_breadcrumb_display_point=>'REGION_POSITION_01'
,p_sidebar_display_point=>'REGION_POSITION_02'
,p_login_template=>wwv_flow_imp.id(236508682288961934)
,p_default_button_template=>wwv_flow_imp.id(236622160639961985)
,p_default_region_template=>wwv_flow_imp.id(236557045854961955)
,p_default_chart_template=>wwv_flow_imp.id(236557045854961955)
,p_default_form_template=>wwv_flow_imp.id(236557045854961955)
,p_default_reportr_template=>wwv_flow_imp.id(236557045854961955)
,p_default_tabform_template=>wwv_flow_imp.id(236557045854961955)
,p_default_wizard_template=>wwv_flow_imp.id(236557045854961955)
,p_default_menur_template=>wwv_flow_imp.id(236566426862961958)
,p_default_listr_template=>wwv_flow_imp.id(236557045854961955)
,p_default_irr_template=>wwv_flow_imp.id(236555122295961954)
,p_default_report_template=>wwv_flow_imp.id(236583898978961966)
,p_default_label_template=>wwv_flow_imp.id(236619619312961984)
,p_default_menu_template=>wwv_flow_imp.id(236623521283961985)
,p_default_calendar_template=>wwv_flow_imp.id(236623659778961985)
,p_default_list_template=>wwv_flow_imp.id(236603570951961975)
,p_default_nav_list_template=>wwv_flow_imp.id(236613371930961980)
,p_default_top_nav_list_temp=>wwv_flow_imp.id(236613371930961980)
,p_default_side_nav_list_temp=>wwv_flow_imp.id(236609988399961977)
,p_default_nav_list_position=>'SIDE'
,p_default_dialogbtnr_template=>wwv_flow_imp.id(236527070826961945)
,p_default_dialogr_template=>wwv_flow_imp.id(236525997957961945)
,p_default_option_label=>wwv_flow_imp.id(236619619312961984)
,p_default_required_label=>wwv_flow_imp.id(236620907136961984)
,p_default_navbar_list_template=>wwv_flow_imp.id(236609545638961977)
,p_file_prefix => nvl(wwv_flow_application_install.get_static_theme_file_prefix(42),'#IMAGE_PREFIX#themes/theme_42/21.1/')
,p_files_version=>64
,p_icon_library=>'FONTAPEX'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#IMAGE_PREFIX#libraries/apex/#MIN_DIRECTORY#widget.stickyWidget#MIN#.js?v=#APEX_VERSION#',
'#THEME_IMAGES#js/theme42#MIN#.js?v=#APEX_VERSION#'))
,p_css_file_urls=>'#THEME_IMAGES#css/Core#MIN#.css?v=#APEX_VERSION#'
);
wwv_flow_imp.component_end;
end;
/
