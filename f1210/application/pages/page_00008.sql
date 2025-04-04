prompt --application/pages/page_00008
begin
--   Manifest
--     PAGE: 00008
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_page.create_page(
 p_id=>8
,p_name=>'Historie'
,p_alias=>'HISTORIE'
,p_step_title=>'Historie'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@date 2022-05 @WISAND @ticket FTTH-47: Neue Spalten zum Vermarktungscluster hinzugef\00FCgt.'),
unistr('@ticket FTTH-3169: //// Mandant-Info hinzuf\00FCgen ')))
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(212005825387553001)
,p_plug_name=>unistr('Presale-/Realizable: Automatisch gel\00F6schte "Siebel-ready"-Objekte')
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>60
,p_plug_grid_column_span=>6
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT LOG.ID',
'     , LOG.DATUM',
'     , LOG.HAUS_LFD_NR',
'     , LOG.VC_LFD_NR',
'     , CASE LOG.MODUS WHEN -1 THEN ''aus VC entfernt'' ELSE ''-'' END AS MODUS',
'     , CASE WHEN LOG.FEHLER > 0 THEN ''Fehler'' END AS FEHLER',
'     , nvl(VC.BEZEICHNUNG, ''(unbekannt)'') AS VERMARKTUNGSCLUSTER',
'  FROM FTTH_LOG_SIEBEL_READY_VCO LOG',
unistr('  LEFT JOIN VERMARKTUNGSCLUSTER VC -- VMC k\00F6nnen gel\00F6scht werden!'),
'    ON (VC.VC_LFD_NR = LOG.VC_LFD_NR)'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>unistr('Presale-/Realizable: Automatisch gel\00F6schte "Siebel-ready"-Objekte')
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_plug_header=>'<p><a href="https://jira.netcologne.intern/browse/FTTH-2698" target="_blank">https://jira.netcologne.intern/browse/FTTH-2698</a>'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@ticket FTTH-2698: Report zeigt s\00E4mtliche Objekte an, die vom Datenbank-Job "JOB_SIEBELREADY_VCO_DEL" gel\00F6scht wurden.'),
'',
unistr('-- Zusammenfassungen aus der Tabelle LOGS anzeigen (Achtung, sehr unperformant, nur f\00FCr Recherchezwecke verwenden):'),
'select to_char(inserted, ''DD.MM.YYYY HH24:MI'') as datum, routine_name, message',
'  from logs where ',
'  inserted > trunc(sysdate) - 14',
'  and action = ''JOB_SIEBELREADY_VCO_DEL'' and module = ''DBMS_SCHEDULER''',
' order by log_id desc;',
''))
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(212005950909553002)
,p_max_row_count=>'1000000'
,p_allow_report_saving=>'N'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_show_display_row_count=>'Y'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_reset=>'N'
,p_show_help=>'N'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>47090089819470326
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006033810553003)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006299806553006)
,p_db_column_name=>'VC_LFD_NR'
,p_display_order=>20
,p_column_identifier=>'D'
,p_column_label=>'VC_LFD_NR'
,p_allow_highlighting=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006596438553009)
,p_db_column_name=>'VERMARKTUNGSCLUSTER'
,p_display_order=>30
,p_column_identifier=>'G'
,p_column_label=>'Vermarktungscluster'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006097062553004)
,p_db_column_name=>'DATUM'
,p_display_order=>40
,p_column_identifier=>'B'
,p_column_label=>'Datum / Uhrzeit'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_format_mask=>'DD.MM.YYYY HH24:MI'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006234095553005)
,p_db_column_name=>'HAUS_LFD_NR'
,p_display_order=>50
,p_column_identifier=>'C'
,p_column_label=>'HAUS_LFD_NR'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(212006701112553010)
,p_db_column_name=>'FEHLER'
,p_display_order=>70
,p_column_identifier=>'H'
,p_column_label=>'Hinweis'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(221637914595657116)
,p_db_column_name=>'MODUS'
,p_display_order=>80
,p_column_identifier=>'I'
,p_column_label=>'Modus'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(217236968845409034)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'523212'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DATUM:HAUS_LFD_NR:VC_LFD_NR:MODUS:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236712146720423929)
,p_plug_name=>'P8_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236712228948423930)
,p_plug_name=>'Vermarktungscluster'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236712412248423932)
,p_plug_name=>'Vermarktungscluster - IG'
,p_parent_plug_id=>wwv_flow_imp.id(236712228948423930)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select ''-'' Typ',
'       , vc_lfd_nr ',
'       , bezeichnung ',
'       , dnsttp_lfD_nr',
'       , url',
'       , url_gk -- 2023-08-15 neu @WISAND',
'       , ausbau_plan_termin',
'       , aktiv',
'       , status',
'       , anz_objekte',
'       , gee_offen',
'       , gee_erteilt',
'       , gee_verweigert',
'       , case when gee_erteilt > 0 then  to_char(round(  (gee_erteilt*100) / anz_objekte ,0)) else ''0'' end || ''%'' quote    ',
'       --, () as quote',
'        -- 2022-05-06 neu @WISAND:',
'       , mindestbandbreite',
'       , zielbandbreite_geplant',
'       , kosten_hausanschluss',
'       , kundenauftrag_erforderlich',
'       , netwissen_seite  ',
'       , mandant',
'from (',
'select  vc.vc_lfd_nr ',
'       , vc.bezeichnung ',
'       , vc.dnsttp_lfD_nr',
'       , vc.url',
'       , vc.url_gk',
'       , vc.ausbau_plan_termin',
'       , nvl(vc.aktiv,0) aktiv',
'       , vc.status',
'       , (select count(1) from vermarktungscluster_objekt vco where  vco.vc_lfd_nr = vc.vc_lfd_nr ) anz_objekte',
'       , (select count(1) ',
'            from vermarktungscluster_objekt vco ',
'           where  vco.vc_lfd_nr = vc.vc_lfd_nr',
'             and strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> vco.haus_lfd_nr) = ''offen'' ',
'             ) gee_offen',
'       , (select count(1) ',
'            from vermarktungscluster_objekt vco ',
'           where  vco.vc_lfd_nr = vc.vc_lfd_nr',
'             and strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> vco.haus_lfd_nr) = ''erteilt'' ',
'             ) gee_erteilt',
'       , (select count(1) ',
'            from vermarktungscluster_objekt vco ',
'           where  vco.vc_lfd_nr = vc.vc_lfd_nr',
'             and strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> vco.haus_lfd_nr) = ''verweigert'' ',
'             )  gee_verweigert',
'            ',
'       --, () as quote',
'        -- 2022-05-06 neu @WISAND:',
'       , mindestbandbreite',
'       , zielbandbreite_geplant',
'       , kosten_hausanschluss',
'       , kundenauftrag_erforderlich',
'       , netwissen_seite  ',
'       , mandant',
'   From vermarktungscluster vc',
')',
'union all',
'(',
unistr('select ''gel\00F6scht'' Typ'),
'       , vc_lfd_nr ',
'       , bezeichnung ',
'       , dnsttp_lfD_nr',
'       , url',
'       , url_gk',
'       , ausbau_plan_termin',
'       , aktiv',
'       , status',
'       , NULL anz_objekte',
'       , NULL gee_offen',
'       , NULL gee_erteilt',
'       , NULL gee_verweigert',
'       , NULL quote',
'        -- 2022-05-06 neu @WISAND:',
'       , mindestbandbreite',
'       , zielbandbreite_geplant',
'       , kosten_hausanschluss',
'       , kundenauftrag_erforderlich',
'       , netwissen_seite',
'       , mandant        ',
'from (',
'    SELECT   versions_starttime',
'       , versions_operation',
'       , vc_lfd_nr',
'       , bezeichnung',
'       , dnsttp_lfd_nr',
'       , url',
'       , url_gk',
'       , status',
'       , ausbau_plan_termin',
'       , aktiv',
'       , inserted',
'       , updated',
'       , inserted_by',
'       , updated_by',
'        -- 2022-05-06 neu @WISAND:',
'       , mindestbandbreite',
'       , zielbandbreite_geplant',
'       , kosten_hausanschluss',
'       , kundenauftrag_erforderlich',
'       , netwissen_seite   ',
'       , mandant      ',
'FROM vermarktungscluster ',
'--VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE',
'VERSIONS BETWEEN     timestamp minvalue and maxvalue',
'WHERE vc_lfd_nr NOT IN (SELECT 1 FROM vermarktungscluster vc2 WHERE vc2.vc_lfd_nr = vc_lfd_nr)',
'AND versions_operation = ''D''',
'ORDER BY versions_starttime desc',
')',
')',
'         '))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Vermarktungscluster - IG'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@date 2022-05 @WISAND @ticket FTTH-47: Neue Spalten zum Grid hinzugef\00FCgt'),
unistr('@krakar @date 2024-06 @ticket FTTH-3169: Spalte Mandant hinzugef\00FCgt')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195842015860111200)
,p_name=>'MINDESTBANDBREITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MINDESTBANDBREITE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mindestbandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199646811932490111)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195842090446111201)
,p_name=>'ZIELBANDBREITE_GEPLANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ZIELBANDBREITE_GEPLANT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'geplante<br/>Zielbandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199647326116498520)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195842242174111202)
,p_name=>'KOSTEN_HAUSANSCHLUSS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KOSTEN_HAUSANSCHLUSS'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Kosten<br/>Hausanschluss'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>190
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195842275431111203)
,p_name=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Kundenauftrag<br/>erforderlich'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199656101876737763)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195842400222111204)
,p_name=>'NETWISSEN_SEITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NETWISSEN_SEITE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Netwissen'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(201843444677948488)
,p_name=>'URL_GK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL_GK'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Landing Page (GK)'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(221067540980858200)
,p_name=>'MANDANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MANDANT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Mandant'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>2
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_column_comment=>unistr('@krakar @date 2024-06-12 @ticket FTTH-3169: Spalte hinzugef\00FCgt')
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769769336588164)
,p_name=>'VC_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VC_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Vc Lfd Nr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>40
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769815552588165)
,p_name=>'BEZEICHNUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BEZEICHNUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Bezeichnung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769928653588166)
,p_name=>'DNSTTP_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNSTTP_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Technologie'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tdt.dnsttp_bez, dnsttp_lfd_nr',
'from  tab_dienst_typ tdt '))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800294070601717)
,p_name=>'URL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Landing Page (PK)'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800294970601718)
,p_name=>'AUSBAU_PLAN_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAU_PLAN_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Ausbau Plan Termin'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>80
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800426090601719)
,p_name=>'AKTIV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AKTIV'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Aktiv'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC2:Ja;1,Nein;0'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800532374601720)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>'SELECT disp_val, ret_val FROM core.v_lov_ausbaustatus '
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800616910601721)
,p_name=>'ANZ_OBJEKTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ANZ_OBJEKTE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Anz Objekte'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800717375601722)
,p_name=>'GEE_OFFEN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_OFFEN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Gee Offen'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800886356601723)
,p_name=>'GEE_ERTEILT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_ERTEILT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Gee Erteilt'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236800949557601724)
,p_name=>'GEE_VERWEIGERT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_VERWEIGERT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Gee Verweigert'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236801037347601725)
,p_name=>'QUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUOTE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Quote'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>150
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>41
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871924328651235)
,p_name=>'TYP'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TYP'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Vermarktungscluster'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>8
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(236769323251588160)
,p_internal_uid=>10320728394486244
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(236807048392604469)
,p_interactive_grid_id=>wwv_flow_imp.id(236769323251588160)
,p_static_id=>'103585'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(236807198980604469)
,p_report_id=>wwv_flow_imp.id(236807048392604469)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164919818626264013)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(201843444677948488)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202045992167743041)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(195842015860111200)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>124
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202047422032743044)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(195842090446111201)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>111
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202048817273743048)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(195842242174111202)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>108
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202050165576743052)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(195842275431111203)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>108
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202051565207743055)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(195842400222111204)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(221073690766859367)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(221067540980858200)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>76
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236810427017604476)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(236769769336588164)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236811323020604477)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(236769815552588165)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>322
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236812249631604479)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(236769928653588166)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>95
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236813176688604480)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(236800294070601717)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236814013446604482)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(236800294970601718)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>140
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236814951214604483)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(236800426090601719)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>55
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236815878430604485)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(236800532374601720)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>177
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236816736766604486)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(236800616910601721)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>95
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236817624334604488)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(236800717375601722)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>84
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236818562859604489)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(236800886356601723)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>86
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236819410588604492)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(236800949557601724)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>103
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236820311116604494)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(236801037347601725)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>60
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236891247250689908)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(236871924328651235)
,p_is_visible=>false
,p_is_frozen=>false
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226448989501101916)
,p_view_id=>wwv_flow_imp.id(236807198980604469)
,p_execution_seq=>5
,p_name=>'Delete'
,p_background_color=>'#ffd6d2'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236871924328651235)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>unistr('gel\00F6scht')
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236712348447423931)
,p_plug_name=>'Vermarktungscluster Objekte - Historie'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236712785102423935)
,p_plug_name=>'Vermarktungscluster Objekte - Historie - IR'
,p_parent_plug_id=>wwv_flow_imp.id(236712348447423931)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT   versions_startscn',
'       , versions_starttime',
'       , versions_endscn',
'       , versions_endtime',
'       , versions_xid',
'       , versions_operation',
'       , vco_lfd_nr',
'       , vc_lfd_nr',
'       , vermarktungscluster_objekt.haus_lfd_nr',
'       , CASE vermarktungscluster_objekt.eigentuemerdaten_notwendig ',
'              WHEN 1 THEN ''ja'' WHEN 0 THEN ''nein'' END AS eigentuemerdaten_notwendig',
'       , g.typ ',
'       , g.id',
'       , g.gebiet',
'       , p.plz_oname ort',
'       , p.plz_plz plz ',
'       , s.str_name46 str ',
'       , h.haus_hnr hnr ',
'       , h.haus_hnr_zus hnr_zus',
'       --, h.haus_lfd_nr haus_lfd_nr',
'       , h.haus_we_ges we_ges',
'       , tdt.dnsttp_bez dnsttp_bez ',
'       , strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status ',
'       , strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am',
'       , hast.has_termin termin',
'       , hast.has_ausbau_status ausbaustatus',
'       , vermarktungscluster_objekt.inserted',
'       , vermarktungscluster_objekt.updated',
'       , vermarktungscluster_objekt.inserted_by',
'       , vermarktungscluster_objekt.updated_by   ',
'       , coalesce(vermarktungscluster_objekt.updated_by, vermarktungscluster_objekt.inserted_by) benutzer',
'FROM vermarktungscluster_objekt VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE',
'     inner join strav.haus h on h.haus_lfd_nr = vermarktungscluster_objekt.haus_lfd_nr',
'     INNER JOIN strav.stra_db s ON s.str_lfd_nr = h.str_lfd_nr',
'     INNER JOIN strav.plz_da p ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort',
'     LEFT OUTER JOIN  strav.haus_gebiet hg ON hg.haus_lfd_nr = h.haus_lfd_nr ',
'     LEFT OUTER JOIN  strav.gebiet g ON g.id = hg.gebiet_id ',
'     LEFT OUTER JOIN strav.haus_daten hd ON hd.haus_lfd_nr = h.haus_lfd_nr',
'     LEFT OUTER JOIN tab_dienst_typ tdt ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr',
'     left outer join strav.haus_ausbau_status hast on hast.haus_lfd_nr = h.haus_lfd_nr',
'',
'',
'',
'',
'--WHERE versions_operation = ''D''',
'--ORDER BY versions_starttime desc'))
,p_plug_source_type=>'NATIVE_IG'
,p_master_region_id=>wwv_flow_imp.id(236712412248423932)
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Vermarktungscluster Objekte - Historie - IR'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@date 2023-08-15 @wisand Tabellen-Qualifier eingef\00FCgt f\00FCr INSERTED, UPDATED, INSERTED_BY, UPDATED_BY ("vorher: column ambigously defined")'),
unistr('/// @kl\00E4ren mit @holger: Kann Seite 2 weg?')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(178846771137168694)
,p_name=>'EIGENTUEMERDATEN_NOTWENDIG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EIGENTUEMERDATEN_NOTWENDIG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>unistr('Eigent\00FCmerdaten<br/>notwendig')
,p_heading_alignment=>'CENTER'
,p_display_sequence=>360
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_column_comment=>'@ticket FTTH-3169'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236805133705601766)
,p_name=>'VERSIONS_STARTSCN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_STARTSCN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Versions Startscn'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870112065651217)
,p_name=>'VERSIONS_STARTTIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_STARTTIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Zeitpunkt'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_format_mask=>'dd.mm.yyyy hh24:mi:ss'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870269154651218)
,p_name=>'VERSIONS_ENDSCN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_ENDSCN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Versions Endscn'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870358649651219)
,p_name=>'VERSIONS_ENDTIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_ENDTIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Versions Endtime'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870398400651220)
,p_name=>'VERSIONS_XID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_XID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Versions Xid'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>8
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870569669651221)
,p_name=>'VERSIONS_OPERATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_OPERATION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Operation'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC2:INSERT;I,UPDATE;U,DELETE;D'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236870658058651222)
,p_name=>'VC_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VC_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>70
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_parent_column_id=>wwv_flow_imp.id(236769769336588164)
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871295319651229)
,p_name=>'INSERTED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Inserted'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871461023651230)
,p_name=>'UPDATED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Updated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871496040651231)
,p_name=>'INSERTED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Inserted By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871684075651232)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236871823942651234)
,p_name=>'HAUS_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAUS_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Haus Lfd Nr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>190
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872084423651236)
,p_name=>'TYP'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TYP'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Typ'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872173580651237)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>210
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872263747651238)
,p_name=>'ORT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Ort'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>40
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872308242651239)
,p_name=>'PLZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PLZ'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Plz'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872435118651240)
,p_name=>'STR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STR'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Str'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>46
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872548209651241)
,p_name=>'HNR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Hnr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872643890651242)
,p_name=>'HNR_ZUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR_ZUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hnr Zus'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>260
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>1
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872769217651243)
,p_name=>'WE_GES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WE_GES'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'WE Gesamt'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872829361651244)
,p_name=>'DNSTTP_BEZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNSTTP_BEZ'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Dnsttp Bez'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>280
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>25
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236872989767651245)
,p_name=>'GEE_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Gee Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>290
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873038023651246)
,p_name=>'GEE_ERTEILT_AM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_ERTEILT_AM'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Gee Erteilt Am'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>300
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873135907651247)
,p_name=>'TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Termin'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>310
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873279593651248)
,p_name=>'AUSBAUSTATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAUSTATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Ausbaustatus'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>320
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873337587651249)
,p_name=>'BENUTZER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BENUTZER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Benutzer'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>330
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873659029651252)
,p_name=>'GEBIET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEBIET'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Gebiet'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>340
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873796800651254)
,p_name=>'VCO_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VCO_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Vco Lfd Nr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>350
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(236804939776601764)
,p_internal_uid=>10356344919499848
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(236876074913658781)
,p_interactive_grid_id=>wwv_flow_imp.id(236804939776601764)
,p_static_id=>'104275'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(236876217910658781)
,p_report_id=>wwv_flow_imp.id(236876074913658781)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164654613562490679)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>28
,p_column_id=>wwv_flow_imp.id(178846771137168694)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(226460769055105553)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(236873659029651252)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(226483541268634507)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>27
,p_column_id=>wwv_flow_imp.id(236873796800651254)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236876783554658783)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(236805133705601766)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236877649604658785)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(236870112065651217)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>130
,p_sort_order=>1
,p_sort_direction=>'DESC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236878588960658787)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(236870269154651218)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236879405651658789)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(236870358649651219)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236880296455658791)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(236870398400651220)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236881256255658795)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(236870569669651221)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>115
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236882181735658797)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(236870658058651222)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236883026189658799)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(236871295319651229)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236883940937658801)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(236871461023651230)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236884844461658802)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(236871496040651231)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236885716528658804)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(236871684075651232)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236887507038658807)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(236871823942651234)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236935801696983441)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(236872084423651236)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236936767512983445)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(236872173580651237)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236937675493983447)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(236872263747651238)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236938476298983449)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(236872308242651239)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236939315299983450)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(236872435118651240)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>155
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236940265597983452)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(236872548209651241)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236941112771983454)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(236872643890651242)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236942044461983455)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>21
,p_column_id=>wwv_flow_imp.id(236872769217651243)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236942950347983457)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>22
,p_column_id=>wwv_flow_imp.id(236872829361651244)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236943846049983459)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>23
,p_column_id=>wwv_flow_imp.id(236872989767651245)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236944785132983461)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>24
,p_column_id=>wwv_flow_imp.id(236873038023651246)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236945645392983463)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>25
,p_column_id=>wwv_flow_imp.id(236873135907651247)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236946503826983464)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>26
,p_column_id=>wwv_flow_imp.id(236873279593651248)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236960933212990991)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(236873337587651249)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>115
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226522595414687576)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_execution_seq=>5
,p_name=>'Delete'
,p_background_color=>'#ffd6d2'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236870569669651221)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'DELETE'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226523024967687577)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_execution_seq=>3.75
,p_name=>'Update'
,p_background_color=>'#fff5ce'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236870569669651221)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'UPDATE'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226523541126687577)
,p_view_id=>wwv_flow_imp.id(236876217910658781)
,p_execution_seq=>2.5
,p_name=>'Insert'
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236870569669651221)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'INSERT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236873457569651250)
,p_plug_name=>'Vermarktungscluster - Historie'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('@date 2022-05-13 @WISAND @ticket FTTH-47 Neue Spalten zur Historie hinzugef\00FCgt')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236713083887423938)
,p_plug_name=>'Historie -IG'
,p_parent_plug_id=>wwv_flow_imp.id(236873457569651250)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT   versions_startscn',
'       , versions_starttime',
'       , versions_endscn',
'       , versions_endtime',
'       , versions_xid',
'       , versions_operation',
'    ',
'       , vc_lfd_nr',
'       --, CASE WHEN lead(bezeichnung) over (ORDER BY versions_starttime desc) <> bezeichnung THEN ''<b>''||bezeichnung ||''</b>'' ELSE bezeichnung END bezeichnung',
'       , bezeichnung',
'       , dnsttp_lfd_nr',
'       , url',
'       , url_gk -- 2023-08-15 neu @WISAND',
'       , status',
'       , ausbau_plan_termin',
'       , aktiv',
'       , inserted',
'       , updated',
'       , inserted_by',
'       , updated_by',
'       , coalesce(updated_by,inserted_by) benutzer',
'        -- 2022-05-06 neu @WISAND:',
'       , mindestbandbreite',
'       , zielbandbreite_geplant',
'       , kosten_hausanschluss',
'       , kundenauftrag_erforderlich',
'       , netwissen_seite',
'       , mandant',
'FROM vermarktungscluster VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE',
'--WHERE versions_operation = ''D''',
'--ORDER BY versions_starttime desc'))
,p_plug_source_type=>'NATIVE_IG'
,p_master_region_id=>wwv_flow_imp.id(236712412248423932)
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Historie -IG'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
,p_plug_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@date 2022-05 @WISAND @ticket FTTH-47: Neue Spalten zur Historie hinzugef\00FCgt'),
unistr('@krakar @date 2024-06 @ticket FTTH-3169: Spalte Mandant hinzugef\00FCgt')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195841539914111195)
,p_name=>'MINDESTBANDBREITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MINDESTBANDBREITE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mindestbandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199646811932490111)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195841583596111196)
,p_name=>'ZIELBANDBREITE_GEPLANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ZIELBANDBREITE_GEPLANT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Geplante<br/>Zielbandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199647326116498520)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195841741503111197)
,p_name=>'KOSTEN_HAUSANSCHLUSS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KOSTEN_HAUSANSCHLUSS'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Kosten<br/>Hausanschluss'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>210
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195841778836111198)
,p_name=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Kundenauftrag<br/>erforderlich'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199656101876737763)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195841882881111199)
,p_name=>'NETWISSEN_SEITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NETWISSEN_SEITE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Netwissen'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(201843320112948487)
,p_name=>'URL_GK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL_GK'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Landing Page (GK)'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>255
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(221067709860858201)
,p_name=>'MANDANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MANDANT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Mandant'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>250
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>2
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
,p_column_comment=>'@ticket FTTH-3169'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236767649826588143)
,p_name=>'VERSIONS_STARTSCN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_STARTSCN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Versions Startscn'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236767774055588144)
,p_name=>'VERSIONS_STARTTIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_STARTTIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Zeitpunkt'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>20
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_format_mask=>'dd.mm.yyyy hh24:mi:ss'
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236767853671588145)
,p_name=>'VERSIONS_ENDSCN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_ENDSCN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Versions Endscn'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236767985742588146)
,p_name=>'VERSIONS_ENDTIME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_ENDTIME'
,p_data_type=>'TIMESTAMP'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Versions Endtime'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768027391588147)
,p_name=>'VERSIONS_XID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_XID'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Versions Xid'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>8
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768163055588148)
,p_name=>'VERSIONS_OPERATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERSIONS_OPERATION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Operation'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>60
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC2:INSERT;I,UPDATE;U,DELETE;D'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768206669588149)
,p_name=>'VC_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VC_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>70
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_is_primary_key=>false
,p_parent_column_id=>wwv_flow_imp.id(236769769336588164)
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768386815588150)
,p_name=>'BEZEICHNUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BEZEICHNUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_HTML_EXPRESSION'
,p_heading=>'Bezeichnung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'html_expression', '&BEZEICHNUNG.')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768439923588151)
,p_name=>'DNSTTP_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNSTTP_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Technologie'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select tdt.dnsttp_bez, dnsttp_lfd_nr',
'from  tab_dienst_typ tdt '))
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768558014588152)
,p_name=>'URL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Landing Page (PK)'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768675731588153)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SQL_QUERY'
,p_lov_source=>'SELECT disp_val, ret_val FROM core.v_lov_ausbaustatus '
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768738948588154)
,p_name=>'AUSBAU_PLAN_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAU_PLAN_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Ausbau Plan Termin'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768841353588155)
,p_name=>'AKTIV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AKTIV'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Aktiv'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC2:Ja;1,Nein;0'
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236768941060588156)
,p_name=>'INSERTED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Inserted'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769062339588157)
,p_name=>'UPDATED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Updated'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769111678588158)
,p_name=>'INSERTED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Inserted By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236769203293588159)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236873552123651251)
,p_name=>'BENUTZER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BENUTZER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Benutzer'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(236767542644588142)
,p_internal_uid=>10318947787486226
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(236784467154599218)
,p_interactive_grid_id=>wwv_flow_imp.id(236767542644588142)
,p_static_id=>'103359'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(236784642715599218)
,p_report_id=>wwv_flow_imp.id(236784467154599218)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202035579528709463)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(195841539914111195)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>135
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202036477489709465)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(195841583596111196)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>116
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202037422033709467)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>21
,p_column_id=>wwv_flow_imp.id(195841741503111197)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>112
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202038286908709470)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>22
,p_column_id=>wwv_flow_imp.id(195841778836111198)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>114
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(202039247763709472)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>23
,p_column_id=>wwv_flow_imp.id(195841882881111199)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(204948091415251417)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>25
,p_column_id=>wwv_flow_imp.id(201843320112948487)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(221075839862205846)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(221067709860858201)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>83
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236785170416599223)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(236767649826588143)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236786050235599225)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(236767774055588144)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>130
,p_sort_order=>1
,p_sort_direction=>'DESC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236786913793599227)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(236767853671588145)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236787839450599228)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(236767985742588146)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236788745249599230)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(236768027391588147)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236789650691599232)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(236768163055588148)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>84
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236790523613599234)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(236768206669588149)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236791468454599235)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(236768386815588150)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>324
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236792387527599237)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(236768439923588151)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>119
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236793220674599239)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>24
,p_column_id=>wwv_flow_imp.id(236768558014588152)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>600
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236794171137599240)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(236768675731588153)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>159
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236795024889599242)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(236768738948588154)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>140
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236795918058599243)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(236768841353588155)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>55
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236796807517599245)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(236768941060588156)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236797734469599247)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(236769062339588157)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236798531612599248)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(236769111678588158)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236799454409599250)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(236769203293588159)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237051561923009122)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(236873552123651251)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>115
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226448954421101917)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_execution_seq=>20
,p_name=>'Delete'
,p_background_color=>'#ffd6d2'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236768163055588148)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'DELETE'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226449466852101917)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_execution_seq=>10
,p_name=>'Update'
,p_background_color=>'#fff5ce'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236768163055588148)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'UPDATE'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226449952986101917)
,p_view_id=>wwv_flow_imp.id(236784642715599218)
,p_execution_seq=>5
,p_name=>'Insert'
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236768163055588148)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'INSERT'
,p_is_enabled=>true
);
wwv_flow_imp.component_end;
end;
/
