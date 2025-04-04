prompt --application/pages/page_00013
begin
--   Manifest
--     PAGE: 00013
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
 p_id=>13
,p_name=>'Vermarktungscluster-Historie'
,p_alias=>'VC-HISTORIE'
,p_step_title=>'Vermarktungscluster-Historie'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.scrollbar-on-top .a-GV-w-hdr{overflow-x:auto!important}',
'',
'div.t-Region-header {',
'  margin-bottom: 1em;',
'}',
'',
'div.contentGroup {',
'  border: 2px solid transparent;',
'}',
'',
'div.problem {',
'  background-color: #FFA;',
'  margin: 20px!important;',
'  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);',
'}',
'',
'div.contentGroup.dirty {',
'  background-color: #FFA!important;',
'  border: 2px dashed #666;',
'  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);',
'}',
'',
'.customCSS.noEdit {',
'   cursor: default; ',
'/*',
'   pointer-events: none;',
'   -webkit-user-select: none;',
'   -moz-user-select: none;',
'   -ms-user-select: none;',
'   user-select: none;',
'*/   ',
'}',
'.customCSS.noEdit:hover,',
'div.customCSS.noEdit *:hover,',
'span.a-Switch-toggle.noEdit {',
'  cursor: not-allowed;   ',
'}',
'',
'.customCSS:disabled {',
'  background-color:#EEE;',
'  opacity:1!important;',
'  cursor:not-allowed;',
'}',
'.a-Switch input[type="checkbox"]:disabled + .a-Switch-toggle {',
'  opacity:1!important;',
'  cursor:not-allowed;',
'}',
'',
'.t-NavigationBar-item.has-username .t-Button-label {',
'  text-transform: none!important;',
'}',
'',
'li.a-MenuBar-item.a-Menu--current {',
'    background-color: #0469C7; /** ein Hauch dunkler als der Glascontainer-Titel **/;',
'}',
''))
,p_step_template=>wwv_flow_imp.id(79256445261925677)
,p_page_template_options=>'#DEFAULT#'
,p_page_comment=>'@krakar @Ticket Ftth-3187: Erstellen einer Seite zur Historisierung des Vermarktungsclusters'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(79640037385480344)
,p_plug_name=>'Vermarktungscluster-Historie:'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(86246760259892865)
,p_plug_name=>'Markierung'
,p_parent_plug_id=>wwv_flow_imp.id(79640037385480344)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(88836393416802469)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(322302104539363720)
,p_plug_name=>'Vermarktungscluster-Historie:'
,p_region_name=>'VC_HIST'
,p_parent_plug_id=>wwv_flow_imp.id(79640037385480344)
,p_region_css_classes=>'scrollbar-on-top'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--noBorders'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT DISTINCT  CASE WHEN vh.operation = ''U'' THEN ''Ge\00E4ndert'' WHEN vh.operation = ''I'' THEN ''Eingef\00FCgt'' WHEN vh.operation = ''D'' THEN ''Gel\00F6scht'' END operation'),
'       , vco_lfd_nr',
'       , vermarktungscluster_objekt.vc_lfd_nr',
'       , vermarktungscluster_objekt.haus_lfd_nr',
'       , p.plz_plz plz ',
'       , p.plz_oname ort',
'       , s.str_name46 str ',
'       , h.haus_hnr hnr ',
'       , h.haus_hnr_zus hnr_zus',
'       , h.haus_we_ges we_ges',
'       , vc.bezeichnung vermarktungscluster',
'       , vc.wholebuy wholebuy_partner',
'       , vc.inserted ',
'       , vc.updated',
'       , vc.mandant ',
'       , vh.aktueller_status',
'       , vh.vorheriger_status',
'       , vh.status_aenderungsdatum',
'       , vh.aktueller_ausbau_plan_termin',
'       , vh.vorheriger_ausbau_plan_termin',
'       , vh.ausbau_plan_termin_aenderungsdatum',
'       , TO_CHAR(vh.aenderungsdatum, ''DD.MM.YYYY HH24:MI:SS'') as aenderungsdatum',
'       , CASE WHEN (vh.status_aenderungsdatum IS NOT NULL AND vh.status_aenderungsdatum >= SYSDATE - :P13_ZEITSPANNE) THEN ''S_EDIT'' END status_markierung',
'       , CASE WHEN (ausbau_plan_termin_aenderungsdatum IS NOT NULL AND vh.ausbau_plan_termin_aenderungsdatum >= SYSDATE - :P13_ZEITSPANNE) THEN ''PT_EDIT'' END plantermin_markierung',
'       , CASE WHEN (vh.aenderungsdatum IS NOT NULL AND vh.aenderungsdatum >= SYSDATE - :P13_ZEITSPANNE) THEN ''D_EDIT'' END operation_markierung',
'FROM vermarktungscluster_objekt VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE',
'     inner join strav.haus h on h.haus_lfd_nr = vermarktungscluster_objekt.haus_lfd_nr',
'     INNER JOIN strav.stra_db s ON s.str_lfd_nr = h.str_lfd_nr',
'     INNER JOIN strav.plz_da p ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort',
'     LEFT JOIN vermarktungscluster vc ON vc.vc_lfd_nr = vermarktungscluster_objekt.vc_lfd_nr',
'     JOIN vc_hist vh ON vh.vc_lfd_nr = vermarktungscluster_objekt.vc_lfd_nr'))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
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
,p_ai_enabled=>false
,p_plug_comment=>'@krakar @Ticket FTTH-3187: Erstellen eines Reports mit angeforderten Daten'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(81267098633030077)
,p_name=>'OPERATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OPERATION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Operation'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>10
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>9
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
 p_id=>wwv_flow_imp.id(81267217936030078)
,p_name=>'VCO_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VCO_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Vco Lfd Nr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>30
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81267287636030079)
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
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81267347807030080)
,p_name=>'HAUS_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAUS_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Hauslaufende <br> Nummer'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81267527852030081)
,p_name=>'PLZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PLZ'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'PLZ'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81267600290030082)
,p_name=>'ORT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Ort'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
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
 p_id=>wwv_flow_imp.id(81267638843030083)
,p_name=>'STR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STR'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>unistr('Stra\00DFe')
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
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
 p_id=>wwv_flow_imp.id(81267823264030084)
,p_name=>'HNR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Hausnummer'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81267856949030085)
,p_name=>'HNR_ZUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR_ZUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hausnummern-<br>zusatz'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
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
 p_id=>wwv_flow_imp.id(81267993137030086)
,p_name=>'WE_GES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WE_GES'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'WE Gesamt'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
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
 p_id=>wwv_flow_imp.id(81268116455030087)
,p_name=>'VERMARKTUNGSCLUSTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VERMARKTUNGSCLUSTER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Vermarktungscluster'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
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
 p_id=>wwv_flow_imp.id(81268226031030088)
,p_name=>'WHOLEBUY_PARTNER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WHOLEBUY_PARTNER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Wholebuypartner'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>30
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
 p_id=>wwv_flow_imp.id(81268304606030089)
,p_name=>'INSERTED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Datum <br>Inserted'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(81268335306030090)
,p_name=>'UPDATED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Datum <br>Updated'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(86244347126892841)
,p_name=>'MANDANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MANDANT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Mandant'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>140
,p_value_alignment=>'LEFT'
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
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(86244469351892842)
,p_name=>'AKTUELLER_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AKTUELLER_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Aktueller <br>Objektstatus'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
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
 p_id=>wwv_flow_imp.id(86244536618892843)
,p_name=>'VORHERIGER_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VORHERIGER_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Vorheriger <br>Objektstatus'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>180
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
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
 p_id=>wwv_flow_imp.id(86244673409892844)
,p_name=>'STATUS_AENDERUNGSDATUM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS_AENDERUNGSDATUM'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Datum Objektstatus <br>Updated'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(86244735559892845)
,p_name=>'AKTUELLER_AUSBAU_PLAN_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AKTUELLER_AUSBAU_PLAN_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Aktueller <br>Plantermin'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(86244913701892846)
,p_name=>'VORHERIGER_AUSBAU_PLAN_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VORHERIGER_AUSBAU_PLAN_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Vorheriger <br>Plantermin'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(86244974069892847)
,p_name=>'AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAU_PLAN_TERMIN_AENDERUNGSDATUM'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Datum Plantermin <br>Updated'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
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
 p_id=>wwv_flow_imp.id(86245053299892848)
,p_name=>'AENDERUNGSDATUM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AENDERUNGSDATUM'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>unistr('\00C4nderungsdatum')
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_format_mask=>'DD-MON-YYYY HH24:MI:SS'
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(86248308530892880)
,p_name=>'STATUS_MARKIERUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS_MARKIERUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status Markierung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>6
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
 p_id=>wwv_flow_imp.id(86248393057892881)
,p_name=>'PLANTERMIN_MARKIERUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PLANTERMIN_MARKIERUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Plantermin Markierung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>7
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
 p_id=>wwv_flow_imp.id(86248488979892882)
,p_name=>'OPERATION_MARKIERUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'OPERATION_MARKIERUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Operation Markierung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>250
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>6
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
 p_id=>wwv_flow_imp.id(81267028437030076)
,p_internal_uid=>19734294670010836
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>false
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(86250138371893167)
,p_interactive_grid_id=>wwv_flow_imp.id(81267028437030076)
,p_static_id=>'247175'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>50
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(86250425240893168)
,p_report_id=>wwv_flow_imp.id(86250138371893167)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(61542704992663661)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>23
,p_column_id=>wwv_flow_imp.id(86248308530892880)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(61544482451663668)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>24
,p_column_id=>wwv_flow_imp.id(86248393057892881)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(61546296456663672)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>25
,p_column_id=>wwv_flow_imp.id(86248488979892882)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86250835524893175)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(81267098633030077)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>77
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86251777883893181)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(81267217936030078)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86252703280893184)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(81267287636030079)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86253573786893187)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(81267347807030080)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>102
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86254519954893189)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(81267527852030081)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>59
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86255396646893193)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(81267600290030082)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>87
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86256247353893196)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(81267638843030083)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>135
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86257145899893198)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(81267823264030084)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>98
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86258105865893201)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(81267856949030085)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>109
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86258935043893204)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(81267993137030086)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>86
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86259904437893208)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(81268116455030087)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>134
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86260815421893211)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(81268226031030088)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>118
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86261656711893214)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(81268304606030089)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86262570473893216)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(81268335306030090)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>83
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86263489778893220)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(86244347126892841)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>69
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86264345670893222)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(86244469351892842)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>149
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86265262987893225)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(86244536618892843)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>149
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86266167215893228)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(86244673409892844)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>142
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86267047709893231)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(86244735559892845)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86268010459893235)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>21
,p_column_id=>wwv_flow_imp.id(86244913701892846)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>83
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86268925579893238)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>22
,p_column_id=>wwv_flow_imp.id(86244974069892847)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>125
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(86269747411893242)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(86245053299892848)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>128
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(61549783638667217)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_execution_seq=>5
,p_name=>'Markierung neuer Objektstatus'
,p_column_id=>wwv_flow_imp.id(86244469351892842)
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(86248308530892880)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'S_EDIT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(61549916963671604)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_execution_seq=>10
,p_name=>'Markierung alter Objektstatus'
,p_column_id=>wwv_flow_imp.id(86244536618892843)
,p_background_color=>'#e8e8e8'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(86248308530892880)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'S_EDIT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(61549999669675568)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_execution_seq=>15
,p_name=>'Markierung neuer Plantermin'
,p_column_id=>wwv_flow_imp.id(86244735559892845)
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(86248393057892881)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'PT_EDIT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(61550148339679270)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_execution_seq=>20
,p_name=>'Markierung alter Plantermin'
,p_column_id=>wwv_flow_imp.id(86244913701892846)
,p_background_color=>'#e8e8e8'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(86248393057892881)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'PT_EDIT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(61550169913681640)
,p_view_id=>wwv_flow_imp.id(86250425240893168)
,p_execution_seq=>2.5
,p_name=>'Markierung Operation'
,p_column_id=>wwv_flow_imp.id(81267098633030077)
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(86248488979892882)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'D_EDIT'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(86248229676892879)
,p_name=>'P13_ZEITSPANNE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(86246760259892865)
,p_item_default=>'30'
,p_pre_element_text=>'<strong> Markierung innerhalb</strong>&nbsp;'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'MARKIERUNG_ZEITSPANNE'
,p_lov=>'.'||wwv_flow_imp.id(89829366741097953)||'.'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(236619594119961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'execute_validations', 'Y',
  'page_action_on_selection', 'SUBMIT')).to_clob
,p_item_comment=>'@krakar @ticket FTTH-3187: Erstellen einer Auswahlliste zur Konfiguration der Zeitspanne, in der die Objekte markiert werden sollen'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(79275375914314604)
,p_name=>'Focus setzen'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(79275841350314604)
,p_event_id=>wwv_flow_imp.id(79275375914314604)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P13_SEARCH_ALL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(89146990711931886)
,p_name=>unistr('Anzahl Tage \00E4ndern')
,p_event_sequence=>60
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#btnAnzahlTage'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(89147152310931888)
,p_event_id=>wwv_flow_imp.id(89146990711931886)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(86249172630892889)
,p_name=>'Submit Page After Change'
,p_event_sequence=>70
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(322302104539363720)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|gridpagechange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(86249243789892890)
,p_event_id=>wwv_flow_imp.id(86249172630892889)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_02=>'Y'
);
wwv_flow_imp.component_end;
end;
/
