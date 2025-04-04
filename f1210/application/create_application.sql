prompt --application/create_application
begin
--   Manifest
--     FLOW: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'ROMA_MAIN')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Vermarktungscluster')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'VERMARKTUNGSCLUSTER')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'047E3EC34A4FC9824EBAD58543B2E0E7D5E551B655D7E0A9DE3867F2A94051AF'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'19.2'
,p_accessible_read_only=>'N'
,p_session_state_commits=>'IMMEDIATE'
,p_flow_language=>'de'
,p_flow_language_derived_from=>'BROWSER'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'dd.mm.yyyy'
,p_date_time_format=>'dd.mm.yyyy hh24:mi:ss'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_direction_right_to_left=>'N'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_documentation_banner=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@krakar @date 2024-06-12: Neue Spalte Mandant in Vermarktungscluster-Historie, @ticket FTTH-3169',
'@WISAND @date 2024-06-04: Neue Spalte MANDANT, @ticket FTTH-3495',
'',
'@WISAND @date 2024-01-31: Page 1 Spalte STATUS umgestellt auf Read Only Select List (nicht mehr basierend auf FOLGESTATUS), damit die Spalte filterbar wird.',
'@WISAND @date 2023-08-15: History angepasst (neue Spalte URL_GK), Abfrage VCO korrigiert',
'@WISAND @date 2023-08-08: @ticket FTTH-2547, @ticket FTTH-2636',
'@WISAND @date 2023-07-20: @ticket FTTH-703, @ticket FTTH-2040, @ticket FTTH-2190',
'@WISAND @date 2023-03-22: @ticket FTTH-1722 PV aus Netzbau-DB anzeigen',
'@WISAND @date 2023-03-22: @ticket FTTH-703 Neue Spalten Seite 1',
'@WISAND @date 2022-11-02: Umbau Seite 4 auf @Hashed Collection',
'@WISAND @date 2022-11-02: Neue Seite 4 ersetzt Seite 5',
'@WISAND @date 2022-11-02: @ticket FTTH-931, @ticket FTTH-668',
'@WISAND @date 2022-04-28: @ticket FTTH-47, @ticket FTTH-84',
'@WISAND @date 2022-04-21: Abfrage Autorisierungsschema umgestellt',
'',
'@date 2021-06-14: Application created from create application wizard',
''))
,p_authentication_id=>wwv_flow_imp.id(41925268616821064)
,p_application_tab_set=>1
,p_logo_type=>'T'
,p_logo_text=>'Vermarktungscluster'
,p_app_builder_icon_name=>'app-icon.svg'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'2024-11-07 1945'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_deep_linking=>'Y'
,p_pass_ecid=>'N'
,p_security_scheme=>wwv_flow_imp.id(238022332535849873)
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_tokenize_row_search=>'N'
,p_friendly_url=>'N'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Vermarktungscluster'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>36
,p_print_server_type=>'INSTANCE'
,p_file_storage=>'DB'
,p_is_pwa=>'N'
);
wwv_flow_imp.component_end;
end;
/
