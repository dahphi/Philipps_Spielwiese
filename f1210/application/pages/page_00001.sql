prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_name=>'Vermarktungscluster'
,p_alias=>'VERMARKTUNGSCLUSTER'
,p_step_title=>'Vermarktungscluster'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>'"JS_IS_VALID_URL"'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.scrollbar-on-top .a-GV-w-hdr{overflow-x:auto!important}',
'#vermarktungsclusterIG span.prozent:after {content:''%''}',
'',
'button#vermarktungsclusterIG_ig_toolbar_m1 {display:none}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@date 2023-07-19 @WISAND @ticket FTTH-2190: Landingpage GK, @ticket FTTH-2509: Statistikspalten auf Basis MV',
unistr('@date 2023-03-14 @WISAND @ticket FTTH-703 @prozent: Drei neue Spalten hinzugef\00FCgt'),
unistr('@date 2022-05-11 @WISAND @ticket FTTH-47: F\00FCnf neue Spalten hinzugef\00FCgt'),
unistr('@date 2022-05-17 @WISAND Validierungen aus IG-Save-Prozess extrahiert, da Codebase zu gro\00DF')))
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(234347981145913749)
,p_plug_name=>'Vermarktungscluster'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(234348077561913750)
,p_plug_name=>'Vermarktungscluster Suche'
,p_parent_plug_id=>wwv_flow_imp.id(234347981145913749)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(234349262920913762)
,p_plug_name=>unistr('Vermarktungscluster \00DCbersicht')
,p_parent_plug_id=>wwv_flow_imp.id(234347981145913749)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_item_display_point=>'BELOW'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(234348629029913756)
,p_plug_name=>'Vermarktungscluster'
,p_region_name=>'vermarktungsclusterIG'
,p_parent_plug_id=>wwv_flow_imp.id(234349262920913762)
,p_region_css_classes=>'scrollbar-on-top'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT details ',
'     , del',
'     , hist',
'     , vc_lfd_nr ',
'     , bezeichnung ',
'     , dnsttp_lfD_nr',
'     , url',
'     , url_gk',
'     , ausbau_plan_termin',
'     , aktiv',
'     , status',
'     , folgestatus',
'     , anz_objekte',
'     , gee_offen',
'     , gee_erteilt',
'     , gee_verweigert',
'     , quote',
'     , mindestbandbreite',
'     , zielbandbreite_geplant',
'     , kosten_hausanschluss',
'     , kundenauftrag_erforderlich',
'     , netwissen_seite',
'     , pob_gesamt',
'     , pob_storno',
'     , pob_aktiv  ',
'     , pob_stornoquote',
'     , pob_gesamtquote',
'     , CASE WHEN pob_gesamt  > 0 THEN ''prozent'' END AS class_pob_stornoquote',
'     , CASE WHEN anz_objekte > 0 THEN ''prozent'' END AS class_pob_gesamtquote',
'     , INSERTED',
'     , INSERTED_BY',
'     , UPDATED',
'     , UPDATED_BY',
'     , WHOLEBUY ',
'     , MANDANT',
'  FROM V_VERMARKTUNGSCLUSTER'))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Vermarktungscluster'
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
unistr('@date 2023-03-09 @WISAND @ticket FTTH-703: Spalten POB_... und neue Column Group hinzugef\00FCgt'),
'@date 2022-05 @WISAND @ticket FTTH-47',
'@date 2024-06-04 Neue Spalte MANDANT, @ticket FTTH-3169'))
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(236215807909552350)
,p_heading=>'GEE'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(265500246189745306)
,p_heading=>'Auftragseingang (PreOrder-Buffer)'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(192180435003872604)
,p_name=>'URL_GK'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL_GK'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Landingpage GK'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>255
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
,p_column_comment=>'@ticket FTTH-2190'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(193799165473638982)
,p_name=>'INSERTED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Inserted'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>330
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
 p_id=>wwv_flow_imp.id(193799274761638983)
,p_name=>'INSERTED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'INSERTED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Inserted By'
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
 p_id=>wwv_flow_imp.id(193799459348638984)
,p_name=>'UPDATED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Updated'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>350
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
 p_id=>wwv_flow_imp.id(193799500876638985)
,p_name=>'UPDATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'UPDATED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Updated By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>360
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
 p_id=>wwv_flow_imp.id(193800641739638996)
,p_name=>'WHOLEBUY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WHOLEBUY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Wholebuy-Partner'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>370
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(224540476061481522)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>'-'
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
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195840141142111181)
,p_name=>'MINDESTBANDBREITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MINDESTBANDBREITE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Mindest-<br/>Bandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>210
,p_value_alignment=>'CENTER'
,p_is_required=>true
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199646811932490111)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>unistr('- bitte ausw\00E4hlen -')
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_help_text=>unistr('Bitte die Bandbreite, die in dem jeweiligen Vermarktungscluster mindestens bestellt werden muss (in Mbit/s) aus der Dropdown-Liste ausw\00E4hlen.')
,p_column_comment=>'@DATE 2022-04-28 @TICKET FTTH-47'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195840195079111182)
,p_name=>'ZIELBANDBREITE_GEPLANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ZIELBANDBREITE_GEPLANT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'geplante<br/>Zielbandbreite'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>220
,p_value_alignment=>'CENTER'
,p_is_required=>true
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199647326116498520)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>unistr('- bitte ausw\00E4hlen -')
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_help_text=>unistr('Bitte die geplante Zielbandbreite im Vermarktungscluster (in Mbit/s) aus der Dropdown-Liste ausw\00E4hlen.')
,p_column_comment=>'@DATE 2022-04-28 @TICKET FTTH-47'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195840308506111183)
,p_name=>'KOSTEN_HAUSANSCHLUSS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KOSTEN_HAUSANSCHLUSS'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Kosten<br/>Hausanschluss'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>230
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_format_mask=>'999G999G999G999G990D00'
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'0'
,p_duplicate_value=>true
,p_include_in_export=>true
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_help_text=>unistr('Kosten des Hausanschlusses f\00FCr Eigent\00FCmer: Betrag in Euro. Nachkommastellen sind erlaubt, Eingabe von 0 ist erlaubt.')
,p_column_comment=>'@DATE 2022-04-28 @TICKET FTTH-47'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195840371524111184)
,p_name=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Kundenauftrag<br/>erforderlich'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>240
,p_value_alignment=>'CENTER'
,p_is_required=>true
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199656101876737763)
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_lov_null_text=>unistr('- bitte ausw\00E4hlen -')
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_help_text=>unistr('Ist f\00FCr einen Hausanschluss zus\00E4tzlich mindestens ein Kundenauftrag erforderlich? (Ja | Nein)')
,p_column_comment=>'@DATE 2022-04-28 @TICKET FTTH-47'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(195840561043111185)
,p_name=>'NETWISSEN_SEITE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'NETWISSEN_SEITE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Netwissen Seite'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>250
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
,p_help_text=>unistr('Bitte die URL der Netwissen-Seite zu diesem Vermarktungscluster eingeben, alternativ deren numerische ID. Wenn keine Eingabe erfolgt, wird hier automatisch ein Link zur Hauptseite "Ausbaugebiete - nach St\00E4dten" eingef\00FCgt.')
,p_column_comment=>'@DATE 2022-04-28 @TICKET FTTH-47'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(197389259786795712)
,p_name=>'EDIT_LINK'
,p_source_type=>'NONE'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_LINK'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:3:P3_VC_LFD_NR:&VC_LFD_NR.'
,p_link_text=>'<img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-pencil.png" class="apex-edit-pencil" alt="">'
,p_link_attributes=>'title="Vermarktungscluster bearbeiten..."'
,p_use_as_row_header=>false
,p_enable_hide=>false
,p_escape_on_http_output=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(215817984337035748)
,p_name=>'MANDANT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MANDANT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Mandant'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>380
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
,p_column_comment=>unistr('@date 2024-06-04 Spalte hinzugef\00FCgt, @ticket FTTH-3169')
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(234349531094913765)
,p_name=>'DETAILS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DETAILS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Objekte'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>30
,p_value_alignment=>'CENTER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_link_target=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:5:P5_VC_ID:&VC_LFD_NR.'
,p_link_text=>'<span class="fa fa-home" aria-hidden="true"></span>'
,p_link_attributes=>unistr('title=''Objekte zuordnen / Status\00E4nderung''')
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
,p_include_in_export=>false
,p_column_comment=>unistr('Ruft Seite 4 f\00FCr die Zuordnung weiterer Objekte zum Vermarktunscluster auf. Der REQUEST ''RESET'' sorgt daf\00FCr, dass die Collection auf Seite 4 zur\00FCckgesetzt wird.')
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236212710243552319)
,p_name=>'URL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'URL'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Landingpage PK'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
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
 p_id=>wwv_flow_imp.id(236212844003552320)
,p_name=>'AUSBAU_PLAN_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAU_PLAN_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'vsl.<br/>Plantermin<br/>Projektende'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236212947874552321)
,p_name=>'AKTIV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AKTIV'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'aktiv'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(199656101876737763)
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236213018273552322)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(188589523509963882)
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@date 2024-01-31: End\00FCltige Umstellung der Spalte STATUS auf Read Only = Always, daher nur noch Anzeige des aktuellen Status per List of Values und nicht mehr die komplizierte Mimik zuvor. Grund: Man konnte auf der Spalte STATUS im IG nicht filtern. ')
||unistr('Inzwischen kann man im IG ja sowieso keine \00C4nderungen mehr vornehmen, sondern nur noch \00FCber das Dialogfenster Page 3.'),
'',
'-- alter Kommentar vor dieser Umstellung:',
unistr('@ticket FTTH-1787: Die LOV zeigt prinzipiell nur noch den aktuellen Status plus diejenigen Status an, die sich aus der Spalte :FOLGESTATUS ergeben. Nachteil dieser Dynamik: Es wird ein Ajax-Request durchgef\00FChrt, wobei sich der Mauszeiger f\00FCr ca. eine')
||unistr(' Sekunde in einen Spinner verwandelt, wenn man die LOV aufklappt. F\00FCr den seltenen Fall einer neu hinzugef\00FCgten Zeile muss per COALESCE die komplette Statusfolge f\00FCr NULL erneut abgerufen werden (daf\00FCr nicht NVL verwenden oder den Folgestatus hart ko')
||unistr('dieren!), weil :FOLGESTATUS nicht vorbelegt ist. Das Cascading-LOV-Attribut "Parent required" muss auf No stehen. @date 2023-04-05: Akzeptanzkriterien besagen, dass hier der Status nicht mehr \00E4nderbar sein soll, daher wird diese Spalte ab Implementie')
||unistr('rung von @FTTH-1787 disabled (=auf "Read Only" umgestellt). Sollte dies zuk\00FCnftig nicht mehr erw\00FCnscht sein, kann durch Wegnahme dieses Attributs der alte LOV-Zustand sofort wiederhergestellt werden (da das SQL dies weiterhin erm\00F6glicht).'),
'',
'LOV-Definition in diesem Fall:',
'SELECT disp_val, ret_val FROM core.v_lov_ausbaustatus WHERE ret_val IN (',
'  SELECT COLUMN_VALUE FROM TABLE(APEX_STRING.SPLIT(COALESCE(:FOLGESTATUS, PCK_VERMARKTUNGSCLUSTER.fv_vc_folgestatus(NULL)), '','')))'))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236213191546552323)
,p_name=>'BEZEICHNUNG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BEZEICHNUNG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Bezeichnung'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
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
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236213425219552326)
,p_name=>'VC_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VC_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>60
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236215652484552348)
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
,p_lov_source=>'select dnsttp_bez d , dnsttp_lfd_nr r from tab_dienst_typ'
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
,p_readonly_condition_type=>'ALWAYS'
,p_readonly_for_each_row=>false
,p_column_comment=>unistr('@date 2024-07-09: \00DCberfl\00FCssige Beschr\00E4nkung "... where dnsttp_lfd_nr in (70,51,71,80)" in LOV-SQL entfernt, @ticket FTTH-3747')
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236215708248552349)
,p_name=>'QUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'QUOTE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Quote'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(236215807909552350)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236712039860423928)
,p_name=>'HIST'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HIST'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading=>'Historie'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>40
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:2:&SESSION.::&DEBUG.:2:P2_VC_LFD_NR:&VC_LFD_NR.'
,p_link_text=>'<span class="fa fa-history" aria-hidden="true"></span>'
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
,p_include_in_export=>false
,p_escape_on_http_output=>true
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238022760528361554)
,p_name=>'ANZ_OBJEKTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ANZ_OBJEKTE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Anzahl<br/>Objekte'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238022805786361555)
,p_name=>'GEE_OFFEN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_OFFEN'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'offen'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(236215807909552350)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238022979734361556)
,p_name=>'GEE_ERTEILT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_ERTEILT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'erteilt'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>120
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(236215807909552350)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238023032414361557)
,p_name=>'GEE_VERWEIGERT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_VERWEIGERT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'verweigert'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(236215807909552350)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238023459515361561)
,p_name=>'DEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEL'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_LINK'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>50
,p_value_alignment=>'CENTER'
,p_link_target=>'javascript:$s(''P1_VC_ID_LOESCHEN'',''&N001.'');'
,p_link_text=>'<span class="fa fa-trash-o" aria-hidden="true"></span>'
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
,p_include_in_export=>false
,p_escape_on_http_output=>true
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265499952014745303)
,p_name=>'POB_STORNO'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POB_STORNO'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Storno'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>280
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(265500246189745306)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'right',
  'virtual_keyboard', 'text')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
unistr('Anzahl der stornierten Auftr\00E4ge im Preorderbuffer, deren HAUS_LFD_NRn zu diesem Vermarktungscluster geh\00F6ren')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500344149745307)
,p_name=>'POB_GESAMT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POB_GESAMT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Brutto'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(265500246189745306)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
unistr('Anzahl der Auftr\00E4ge im Preorderbuffer, deren HAUS_LFD_NRn zu diesem Vermarktungscluster geh\00F6ren')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500421250745308)
,p_name=>'POB_AKTIV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POB_AKTIV'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Netto'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(265500246189745306)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
unistr('Anzahl der nicht stornierten Auftr\00E4ge im Preorderbuffer, deren HAUS_LFD_NRn zu diesem Vermarktungscluster geh\00F6ren')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500558415745309)
,p_name=>'POB_STORNOQUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POB_STORNOQUOTE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HTML_EXPRESSION'
,p_heading=>'Storno-<br/>Quote'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>290
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(265500246189745306)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'html_expression', '<span class="&CLASS_POB_STORNOQUOTE.">&POB_STORNOQUOTE.</span>')).to_clob
,p_format_mask=>'990D00'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
unistr('Auf 2 Nachkommastellen gerundeter Anteil stornierter Auftr\00E4ge f\00FCr HAUS_LFD_NRn, die zu diesem Vermarktungscluster geh\00F6ren')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500648386745310)
,p_name=>'POB_GESAMTQUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'POB_GESAMTQUOTE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HTML_EXPRESSION'
,p_heading=>'Gesamt-</br>Quote'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>310
,p_value_alignment=>'RIGHT'
,p_group_id=>wwv_flow_imp.id(265500246189745306)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'html_expression', '<span class="&CLASS_POB_GESAMTQUOTE.">&POB_GESAMTQUOTE.</span>')).to_clob
,p_format_mask=>'990D00'
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_include_in_export=>true
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
unistr('Auftr\00E4ge im Preorderbuffer im Verh\00E4ltnis zur Anzahl Objekte insegesamt, auf 2 Nachkommastellen gerundet')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500662728745311)
,p_name=>'CLASS_POB_STORNOQUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CLASS_POB_STORNOQUOTE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>300
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_include_in_export=>false
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
'(siehe ".prozent:after" im Page CSS)',
unistr('Ergibt den String "prozent", wenn die Prozentberechnung der Stornoquote g\00FCltig ist (also keine Division durch 0 durchf\00FChrt).'),
unistr('Nur mit einer HTML Expression und dieser CSS-Erg\00E4nzung bekommt man das Prozentzeichen hinter die Zahl, ohne dass gleichzeitig die gesamte Spalte zum String wird und sich dann nicht mehr nummerisch sortieren lie\00DFe.')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(265500775840745312)
,p_name=>'CLASS_POB_GESAMTQUOTE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CLASS_POB_GESAMTQUOTE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>320
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_include_in_export=>false
,p_column_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-703',
'(siehe ".prozent:after" im Page CSS)',
unistr('Ergibt den String "prozent", wenn die Prozentberechnung der Gesamtquote g\00FCltig ist (also keine Division durch 0 durchf\00FChrt).'),
unistr('Nur mit einer HTML Expression und dieser CSS-Erg\00E4nzung bekommt man das Prozentzeichen hinter die Zahl, ohne dass gleichzeitig die gesamte Spalte zum String wird und sich dann nicht mehr nummerisch sortieren lie\00DFe.')))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(282344504357038086)
,p_name=>'FOLGESTATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'FOLGESTATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>200
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_filter_is_required=>false
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>false
,p_include_in_export=>false
,p_column_comment=>unistr('@ticket FTTH-1787: Dient als Liste f\00FCr die Parent Cascading LOV in der Spalte STATUS: Die List of Values zeigt dann nur den aktuellen Status plus diejenigen Status an, die auf den aktuellen Status folgen k\00F6nnen')
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(234348744493913757)
,p_internal_uid=>7900149636811841
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_toolbar_buttons=>'SEARCH_COLUMN:SEARCH_FIELD:ACTIONS_MENU:RESET'
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>false
,p_define_chart_view=>false
,p_enable_download=>true
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(237795253268812316)
,p_interactive_grid_id=>wwv_flow_imp.id(234348744493913757)
,p_static_id=>'113467'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(237795478076812316)
,p_report_id=>wwv_flow_imp.id(237795253268812316)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164920118872193662)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>33
,p_column_id=>wwv_flow_imp.id(193799165473638982)
,p_is_visible=>false
,p_is_frozen=>false
,p_sort_order=>1
,p_sort_direction=>'DESC'
,p_sort_nulls=>'FIRST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164921133983193665)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>34
,p_column_id=>wwv_flow_imp.id(193799274761638983)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164922139484193668)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>35
,p_column_id=>wwv_flow_imp.id(193799459348638984)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164923111890193671)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>36
,p_column_id=>wwv_flow_imp.id(193799500876638985)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(165887546505971786)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>27
,p_column_id=>wwv_flow_imp.id(265500662728745311)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(165963736659036331)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>29
,p_column_id=>wwv_flow_imp.id(265500775840745312)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(192081871643978101)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>30
,p_column_id=>wwv_flow_imp.id(192180435003872604)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>501
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(193737256876933994)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(197389259786795712)
,p_is_visible=>true
,p_is_frozen=>true
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(199650046115695381)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(195840141142111181)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>96
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(199650912866695384)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(195840195079111182)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>111
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(199651828028695386)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(195840308506111183)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>112
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(199652745536695389)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(195840371524111184)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>114
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(199653651840695392)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>31
,p_column_id=>wwv_flow_imp.id(195840561043111185)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>510
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(217904983013178671)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(215817984337035748)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>76
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(222493887322925870)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(193800641739638996)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>148
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(226455591972152707)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>21
,p_column_id=>wwv_flow_imp.id(236215708248552349)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>60
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(226468417479138357)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(236213425219552326)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>108
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236220327802552498)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>28
,p_column_id=>wwv_flow_imp.id(236212710243552319)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>374
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236221283282552501)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(236212844003552320)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>116
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236222151072552502)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(236212947874552321)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>58
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236223057631552504)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(236213018273552322)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>146
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236230459998554910)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(236213191546552323)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>260
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236345256721037383)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(236215652484552348)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>128
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236723805343435865)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(236712039860423928)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>67
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237810691627865474)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(234349531094913765)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>61
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238110421084618338)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(238022760528361554)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>82
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238114529554675213)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(238022805786361555)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>73
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238115485894675216)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(238022979734361556)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>73
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238116338642675218)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(238023032414361557)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238145484320144431)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(238023459515361561)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>45
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(270160028141207505)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>24
,p_column_id=>wwv_flow_imp.id(265499952014745303)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>72
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(273954331201182802)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>22
,p_column_id=>wwv_flow_imp.id(265500344149745307)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(273955202142182808)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>23
,p_column_id=>wwv_flow_imp.id(265500421250745308)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>73
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(273956095701182810)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>25
,p_column_id=>wwv_flow_imp.id(265500558415745309)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>93
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(273957006837182812)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>26
,p_column_id=>wwv_flow_imp.id(265500648386745310)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(283756162777516166)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_display_seq=>32
,p_column_id=>wwv_flow_imp.id(282344504357038086)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(164915984197082685)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_execution_seq=>7.5
,p_name=>'WHOLEBUY-Partner Telekom'
,p_column_id=>wwv_flow_imp.id(193800641739638996)
,p_background_color=>'#e20074'
,p_text_color=>'#ffffff'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(193800641739638996)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Telekom'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(164916044325091495)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_execution_seq=>8.75
,p_name=>'WHOLEBUY-Partner Deutsche Glasfaser'
,p_column_id=>wwv_flow_imp.id(193800641739638996)
,p_background_color=>'#14a0dc'
,p_text_color=>'#ffffff'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(193800641739638996)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Deutsche Glasfaser'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226450057326105475)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_execution_seq=>5
,p_name=>'Aktiv'
,p_column_id=>wwv_flow_imp.id(236212947874552321)
,p_background_color=>'#d0f1cc'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236212947874552321)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Ja'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226451670922109352)
,p_view_id=>wwv_flow_imp.id(237795478076812316)
,p_execution_seq=>6.25
,p_name=>'nicht Aktiv'
,p_column_id=>wwv_flow_imp.id(236212947874552321)
,p_background_color=>'#ffd6d2'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(236212947874552321)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Nein'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236657651956962008)
,p_plug_name=>'Vermarktungscluster'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236547199245961951)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(236499478762961929)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(236623521283961985)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(238023573311361562)
,p_plug_name=>'P1_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(234348584565913755)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(234347981145913749)
,p_button_name=>'P1_VERMARKTUNGSCLUSTER_NEU'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Vertriebscluster'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-plus'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(192181078579872611)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(236657651956962008)
,p_button_name=>'BTN_STATISTIK_AKTUALISIEREN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>'Stand: &P1_STATISTIK_DATUM.'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-line-chart'
,p_button_cattributes=>'title="Statistik aktualisieren ..."'
,p_button_comment=>'@ticket FTTH-2509'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(197386497050795685)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(236657651956962008)
,p_button_name=>'BTN_VERMARKTUNGSCLUSTER_NEU'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Neuer Vermarktungscluster'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(192181482631872615)
,p_name=>'P1_STATISTIK_DATUM'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(234349262920913762)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Speichert, wannn die MV_VERMARKTUNGSCLUSTER_STATISTIK zuletzt aktualisiert wurde'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(192181684806872617)
,p_name=>'P1_POB_UPDATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(238023573311361562)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-2040:',
unistr('Speichert eine kommaseparierte Liste mit VC_LFD_NRn, sofern im Grid-DML festgestellt wurde, dass f\00FCr mindestens einen Vermarktungscluster anschlie\00DFend ein POB-Update durchgef\00FChrt werden muss')))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(193801123546639001)
,p_name=>'P1_VC_LFD_NR_DISPLAY'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(238023573311361562)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('2023-11-09 @ticket FTTH-2901: Nach dem Anlegen eines Vermarktungsclusters f\00FCllt die Eingabemaske (Dialog Seite 3) dieses Item mit der neuen VC_LFD_NR. Dadurch kann beispielsweise der Fokus auf den neuen Vermarktungscluster gesetzt werden.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(234348101372913751)
,p_name=>'P1_STRAV_GEBIETE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(234348077561913750)
,p_prompt=>'Gebiete'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT gebiet || '' ('' || typ || '')'' d, id r',
'  FROM strav.gebiet',
'  ORDER BY gebiet'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(234348338558913753)
,p_name=>'P1_STRAV_TYP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(234348077561913750)
,p_prompt=>'Gebiete'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct gebiet d, gebiet r',
'  FROM strav.gebiet',
'  ORDER BY gebiet'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238023649709361563)
,p_name=>'P1_VC_ID_LOESCHEN'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(238023573311361562)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(192181596047872616)
,p_computation_sequence=>10
,p_computation_item=>'P1_STATISTIK_DATUM'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'QUERY'
,p_computation=>'SELECT TO_CHAR(max(zeit), ''DY DD.MM. YYYY HH24:MI'') || '' Uhr'' FROM MV_VERMARKTUNGSCLUSTER_STATISTIK'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238023712414361564)
,p_name=>unistr('Vertriebscluster l\00F6schen')
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_VC_ID_LOESCHEN'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238023888648361565)
,p_event_id=>wwv_flow_imp.id(238023712414361564)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Wollen Sie das Vertriebscluster wirklich l&#xF6;schen?'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238194482687208017)
,p_name=>'New'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P1_VC_NAME_LOESCHEN'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238194509078208018)
,p_event_id=>wwv_flow_imp.id(238194482687208017)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_03=>'P1_VC_NAME_LOESCHEN'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(192181231907872612)
,p_name=>'STATISTIK_AKTUALISIEREN'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(192181078579872611)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(192181307241872613)
,p_event_id=>wwv_flow_imp.id(192181231907872612)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>unistr('Best\00E4tigen')
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<p>Die Vermarktungscluster-Statistiken (alle Informationen in den Bereichen <strong>GEE</strong> und <strong>Auftragseingang (PreOrder-Buffer)</strong> werden automatisch fr\00FChmorgens aktualisiert.</p>'),
unistr('<p>Sie k\00F6nnen hier eine ad-hoc-Aktualisierung durchf\00FChren &ndash; diese findet im Hintergrund statt und dauert wenige Minuten.</p>'),
'<p>Statistik jetzt aktualisieren?</p>'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(192181410567872614)
,p_event_id=>wwv_flow_imp.id(192181231907872612)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'PCK_VERMARKTUNGSCLUSTER.p_statistik_aktualisieren;'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(172031603593587381)
,p_name=>unistr('IG: Kopieren in Zwischenablage erm\00F6glichen')
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(172065917917053091)
,p_da_event_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Erm\00F6glicht es, den gesamten Inhalt einer markierte Zelle im Interactive Grid in die Zwischenablage zu kopieren.'),
'@copy'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(172031727375587382)
,p_event_id=>wwv_flow_imp.id(172031603593587381)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'copy-Event abfangen'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'document.addEventListener(''copy'', (event) => {',
'    event.clipboardData.setData(''text/plain'', $(document.activeElement)[0].innerText || window.getSelection());',
'    event.preventDefault();',
'});'))
,p_da_action_comment=>'@url https://www.oneoracledeveloper.com/2022/03/copy-cell-value-from-ig-global-edition.html'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(237823295715052164)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Prototyp - Collections erzeugen'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- +-------------+',
'-- | Collections |',
'-- +-------------+',
'',
'-- ----------------',
'-- Vertriebslcuster',
'-- ',
'-- N001 : ID',
'-- C001 : Name',
'-- C002 : Technologie',
'-- C003 : Ausbaustatus',
'-- D001 : Plantermin',
'-- D002 : VVM_von',
'-- D003 : VVM_bis ',
'-- ----------------',
'APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(',
'    p_collection_name => ''VERTRIEBSCLUSTER'');',
'',
'-- Testdaten',
'APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER'',',
'        p_c001            => ''VC 1'',',
'        p_c002            => ''FTTH'',',
'        p_c003            => ''NotPlanned'',',
'        p_n001            => 1,',
'        p_d001            => NULL, ',
'        p_d002            => NULL, ',
'        p_d003            => NULL ',
'        );',
'APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER'',',
'        p_c001            => ''VC 2'',',
'        p_c002            => ''FTTH'',',
'        p_c003            => ''AreaPlanned'',',
'        p_n001            => 2,',
'        p_d001            => NULL, ',
'        p_d002            => NULL, ',
'        p_d003            => NULL ',
'        );',
'APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER'',',
'        p_c001            => ''VC 3'',',
'        p_c002            => ''FTTH'',',
'        p_c003            => ''PreMarketing'',',
'        p_n001            => 3,',
'        p_d001            => sysdate, ',
'        p_d002            => sysdate + 30, ',
'        p_d003            => sysdate + 60 ',
'        );',
'APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER'',',
'        p_c001            => ''VC 4'',',
'        p_c002            => ''FTTH'',',
'        p_c003            => ''underConstruction'',',
'        p_n001            => 4,',
'        p_d001            => NULL, ',
'        p_d002            => NULL, ',
'        p_d003            => NULL ',
'        );',
'-- ------------------------',
'-- Vertriebslcuster Details',
'--',
'-- N001 : VC_ID',
'-- N002 : HAUS_LFD_NR',
'-- ------------------------',
'APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(',
'    p_collection_name => ''VERTRIEBSCLUSTER_DETAILS'');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_internal_uid=>72907434624969488
);
wwv_flow_imp.component_end;
end;
/
