prompt --application/pages/page_00005
begin
--   Manifest
--     PAGE: 00005
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
 p_id=>5
,p_name=>'Vermarktungscluster Objekt'
,p_alias=>'VERMARKTUNGSCLUSTER-OBJEKT'
,p_step_title=>'Vermarktungscluster Objekte'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_page_comment=>unistr('@ticket FTTH-3169: Mandant-Info hinzugef\00FCgt. @date 2024-07-04: Nur bei WHOLEBUY = TCOM wird die Spalte "Eigent\00FCmerdaten notwendig" angezeigt.')
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(193803576568639026)
,p_plug_name=>'WHOLEBUY_PARTNER_DISPLAY'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236526213069961945)
,p_plug_display_sequence=>20
,p_plug_source=>'<div id="WHOLEBUY_PARTNER_&P5_WHOLEBUY." class ="WHOLEBUY_PARTNER_DISPLAY">Wholebuy-Partner: &P5_WHOLEBUY_DISPLAY.</div>'
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P5_WHOLEBUY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>'@ticket FTTH-2901: Zeigt einen Hinweis an, wenn dem Vermarktungscluster ein WHOLEBUY-Partner zugeordnet ist'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(226097871223285377)
,p_plug_name=>'WHOLEBUY CSS'
,p_plug_display_sequence=>10
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'div.WHOLEBUY_PARTNER_DISPLAY {margin:3px 0 12px 0;padding:4px 1em;font-weight:bold;border:1px #666}',
'div#WHOLEBUY_PARTNER_TCOM {Background-color:#e20074;color:#FFF}',
'div#WHOLEBUY_PARTNER_DGF {Background-color:#14a0dc;color:#FFF}'))
,p_plug_display_condition_type=>'ITEM_IS_NOT_NULL'
,p_plug_display_when_condition=>'P5_WHOLEBUY'
,p_plug_header=>'<style>'
,p_plug_footer=>'</style>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('@ticket FTTH-2901: Darstellungsstil des Wholebuy-Hinweises, farbiger Hintergrund f\00FCr bestimmte Partner')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(245701858357656275)
,p_plug_name=>'Objekte im Vermarktungscluster <b>&P5_VC_NAME.</b> <i>(Status: &P5_VC_STATUS_DISP.)</i>'
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>50
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(245702010317656276)
,p_plug_name=>'Vermarktungscluster Objekt - IG'
,p_region_name=>'ADRESSEN_DETAIL_IG'
,p_parent_plug_id=>wwv_flow_imp.id(245701858357656275)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT g.gebiet, ',
'       g.typ, ',
'       g.id,',
'       p.plz_oname ort, ',
'       p.plz_plz plz, ',
'       s.str_name46 str, ',
'       h.haus_hnr hnr, ',
'       h.haus_hnr_zus hnr_zus,',
'       h.haus_lfd_nr haus_lfd_nr,',
'       h.haus_we_ges we_ges,',
'       tdt.dnsttp_bez dnsttp_bez, ',
'       strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, ',
'       strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,',
'       hast.has_termin,',
'       hast.has_ausbau_status,',
'       vco.vco_lfd_nr,',
'     --pv.name pv -- @ticket FTTH-1722',
'       pv.pv_name pv,',
'       CASE vco.eigentuemerdaten_notwendig WHEN 1 THEN ''ja'' WHEN 0 THEN ''nein'' END as eigentuemerdaten_notwendig',
'  FROM VERMARKTUNGSCLUSTER_OBJEKT vco',
'  JOIN      strav.haus               h    ON h.haus_lfd_nr = vco.haus_lfd_nr',
'  JOIN      strav.stra_db            s    ON s.str_lfd_nr = h.str_lfd_nr',
'  JOIN      strav.plz_da             p    ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort',
'  LEFT JOIN strav.haus_gebiet        hg   ON hg.haus_lfd_nr = h.haus_lfd_nr ',
'  LEFT JOIN strav.gebiet             g    ON g.id = hg.gebiet_id',
'  LEFT JOIN strav.haus_daten         hd   ON hd.haus_lfd_nr = h.haus_lfd_nr',
'  LEFT JOIN tab_dienst_typ           tdt  ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr',
'  LEFT join strav.haus_ausbau_status hast ON hast.haus_lfd_nr = h.haus_lfd_nr',
'-- @ticket FTTH-1722: Bisherige Views liefern nur Smallworld-Ergebnisse:',
'--LEFT JOIN strav.V_SW_PV_OBJEKT     pvo  ON pvo.haus_lfd_nr = h.haus_lfd_nr',
'--LEFT JOIN strav.V_SW_PV            pv   ON pv.sw_id = pvo.sw_id',
'-- neue View liefert sowohl Smallworld als auch Netzbau-DB:',
'  LEFT JOIN STRAV.V_HAUS_SW_PV_OBJEKT pv  ON pv.haus_lfd_nr = h.haus_lfd_nr',
' WHERE vco.vc_LFD_NR = :P5_VC_ID'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P5_VC_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Vermarktungscluster Objekt - IG'
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
,p_plug_comment=>unistr('@date 2023-04-12 @WISAND @ticket FTTH-1722: Im SQL Query scheinen bereits die im Ticket erw\00E4hnten Views angebunden zu sein???')
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(236215994948552352)
,p_heading=>'Netzbau'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(236216106409552353)
,p_heading=>'GEE'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(178846662131168693)
,p_name=>'EIGENTUEMERDATEN_NOTWENDIG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EIGENTUEMERDATEN_NOTWENDIG'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>unistr('Eigent\00FCmerdaten<br/>notwendig')
,p_heading_alignment=>'CENTER'
,p_display_sequence=>200
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
,p_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_display_condition=>'P5_WHOLEBUY'
,p_display_condition2=>'TCOM'
,p_column_comment=>unistr('@ticket FTTH-3169: Nur bei WHOLEBUY = TCOM wird die Spalte "Eigent\00FCmerdaten notwendig" angezeigt.')
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(202200913422072193)
,p_name=>'PV'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PV'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'PV'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236215994948552352)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>256
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
 p_id=>wwv_flow_imp.id(236873705127651253)
,p_name=>'VCO_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VCO_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'VCO_LFD_NR'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>160
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
 p_id=>wwv_flow_imp.id(238019944245361526)
,p_name=>'GEBIET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEBIET'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Gebiet'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
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
 p_id=>wwv_flow_imp.id(238020088653361527)
,p_name=>'TYP'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TYP'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Typ'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
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
 p_id=>wwv_flow_imp.id(238020183325361528)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>50
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
 p_id=>wwv_flow_imp.id(238020202709361529)
,p_name=>'ORT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORT'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Ort'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
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
 p_id=>wwv_flow_imp.id(238020325330361530)
,p_name=>'PLZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PLZ'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'PLZ'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>70
,p_value_alignment=>'CENTER'
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
 p_id=>wwv_flow_imp.id(238020443250361531)
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
 p_id=>wwv_flow_imp.id(238020588573361532)
,p_name=>'HNR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Hnr.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>90
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
 p_id=>wwv_flow_imp.id(238020605432361533)
,p_name=>'HNR_ZUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR_ZUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hnr. Zus.'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>100
,p_value_alignment=>'CENTER'
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
 p_id=>wwv_flow_imp.id(238020786683361534)
,p_name=>'HAUS_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAUS_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Haus Lfd Nr'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>110
,p_value_alignment=>'CENTER'
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238020825797361535)
,p_name=>'WE_GES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WE_GES'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'WE Gesamt'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>120
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
 p_id=>wwv_flow_imp.id(238020931121361536)
,p_name=>'DNSTTP_BEZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNSTTP_BEZ'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Technologie'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
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
,p_column_comment=>'Die Technologie-Information kommt aus der Spalte STRAV.HAUS_DATEN (HSB_DNSTTP_LFD_NR)'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238021001206361537)
,p_name=>'GEE_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216106409552353)
,p_use_group_for=>'BOTH'
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
,p_filter_exact_match=>true
,p_filter_lov_type=>'STATIC'
,p_filter_lov_query=>'erteilt,verweigert,offen'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238021152164361538)
,p_name=>'GEE_ERTEILT_AM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_ERTEILT_AM'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'erteilt am'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>150
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216106409552353)
,p_use_group_for=>'BOTH'
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
 p_id=>wwv_flow_imp.id(238022481939361551)
,p_name=>'APEX$ROW_ACTION'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238022589579361552)
,p_name=>'APEX$ROW_SELECTOR'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
,p_use_as_row_header=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(238196873917208041)
,p_name=>'HAS_TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAS_TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Termin'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>190
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236215994948552352)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
 p_id=>wwv_flow_imp.id(238196954534208042)
,p_name=>'HAS_AUSBAU_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAS_AUSBAU_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Ausbaustatus'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236215994948552352)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'STATIC'
,p_filter_lov_query=>'homesPassed,homesPassedPlus,homesPrepared'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(238019817073361525)
,p_internal_uid=>11571222216259609
,p_is_editable=>true
,p_edit_operations=>'d'
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>false
,p_fixed_row_height=>true
,p_pagination_type=>'SET'
,p_show_total_row_count=>true
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
 p_id=>wwv_flow_imp.id(238037137179404332)
,p_interactive_grid_id=>wwv_flow_imp.id(238019817073361525)
,p_static_id=>'115886'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>1000
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(238037384917404333)
,p_report_id=>wwv_flow_imp.id(238037137179404332)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(164646967802451667)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(178846662131168693)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(226476814319141572)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(238022481939361551)
,p_is_visible=>true
,p_is_frozen=>true
,p_width=>40
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(231320708341751351)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(202200913422072193)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>122
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237296445019528052)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(236873705127651253)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238037794997404334)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(238019944245361526)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>159
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238038736431404336)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(238020088653361527)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>101
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238039691807404338)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(238020183325361528)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238040548563404340)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(238020202709361529)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>156
,p_sort_order=>2
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238041423623404343)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(238020325330361530)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>64
,p_sort_order=>1
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238042327074404345)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(238020443250361531)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>142
,p_sort_order=>3
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238043202233404347)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(238020588573361532)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>81
,p_sort_order=>4
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238044058966404349)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(238020605432361533)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>99
,p_sort_order=>5
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238044982427404351)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(238020786683361534)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>72
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238045856657404354)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(238020825797361535)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>80
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238046745701404356)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(238020931121361536)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>143
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238047677049404358)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(238021001206361537)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>86
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238048556077404360)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(238021152164361538)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>96
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238810024241236790)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(238196873917208041)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238810994102236795)
,p_view_id=>wwv_flow_imp.id(238037384917404333)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(238196954534208042)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>125
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(248010193606704520)
,p_plug_name=>'Vermarktungscluster <b>&P5_VC_NAME.</b> Objekte'
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236547199245961951)
,p_plug_display_sequence=>30
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(236499478762961929)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(236623521283961985)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(282344653657038087)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_button_name=>'P5_BTN_STATUS_PREMARKETING'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>'PreMarketing'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P5_VC_FOLGESTATUS LIKE ''%PREMARKETING%'''
,p_button_condition2=>'SQL'
,p_button_condition_type=>'EXPRESSION'
,p_button_css_classes=>'u-color-31'
,p_icon_css_classes=>'fa-arrow-right-alt'
,p_button_comment=>'@ticket FTTH-1787'
,p_required_patch=>wwv_flow_imp.id(300353711591504239)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(282344717221038088)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_button_name=>'P5_BTN_STATUS_UNDERCONSTRUCT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--gapRight'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>'UnderConstruction'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>':P5_VC_FOLGESTATUS LIKE ''%UNDERCONSTRUCTION%'''
,p_button_condition2=>'SQL'
,p_button_condition_type=>'EXPRESSION'
,p_button_css_classes=>'u-color-31'
,p_icon_css_classes=>'fa-arrow-right-alt'
,p_button_comment=>'@ticket FTTH-1787'
,p_required_patch=>wwv_flow_imp.id(300353711591504239)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(282345250616038093)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_button_name=>'P5_BTN_STATUSWECHSEL_NA'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--link:t-Button--gapRight'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>unistr('Kein weiterer Statuswechsel m\00F6glich')
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P5_VC_FOLGESTATUS'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_button_css_classes=>'u-color-31-text'
,p_button_comment=>'@ticket FTTH-1787'
,p_required_patch=>wwv_flow_imp.id(300353711591504239)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211586990754690590)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_button_name=>'P5_BTN_OBJEKTE_NEU'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Objekte hinzuf\00FCgen &hellip;')
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.:RESET:&DEBUG.:4:P4_VC_ID:&P5_VC_ID.'
,p_icon_css_classes=>'fa-plus'
,p_button_comment=>'Verlinkt zur neuen Seite 4, welche die Seite 7 ersetzt (@ticket FTTH-561)'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(193803425826639024)
,p_name=>'P5_WHOLEBUY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('@ticket FTTH-2901: Speichert den Schl\00FCssel f\00FCr den WHOLEBUY-Partner (z.B. ''TCOM'')')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(193803491066639025)
,p_name=>'P5_WHOLEBUY_DISPLAY'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'@ticket FTTH-2901: Speichert den Namen des WHOLEBUY-Partners (z.B. ''Telekom'')'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238019720728361524)
,p_name=>'P5_VC_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('@todo Leider hei\00DFt dieses Item ..._ID anstatt ..._LFD_NR (\00FCberall \00E4ndern? Aufwand?)')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238022036650361547)
,p_name=>'P5_VC_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(282344793499038089)
,p_name=>'P5_VC_STATUS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(282345068518038092)
,p_name=>'P5_VC_FOLGESTATUS'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(282345501517038096)
,p_name=>'P5_VC_STATUS_DISP'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(248010193606704520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(172066321189061941)
,p_name=>unistr('IG: Kopieren in Zwischenablage erm\00F6glichen')
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(172065917917053091)
,p_da_event_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Erm\00F6glicht es, den gesamten Inhalt einer markierte Zelle im Interactive Grid in die Zwischenablage zu kopieren.'),
'@copy'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(172066698812061948)
,p_event_id=>wwv_flow_imp.id(172066321189061941)
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
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(282345297754038094)
,p_name=>unistr('Link "Kein Statuswechsel m\00F6glich"')
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(282345250616038093)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(282345362241038095)
,p_event_id=>wwv_flow_imp.id(282345297754038094)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ALERT'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Dieser Vermarktungscluster befindet sich im Status &P5_VC_STATUS_DISP.. <br/>',
'Ein Statuswechsel ist nicht vorgesehen.'))
,p_attribute_02=>unistr('Kein Statuswechsel m\00F6glich')
,p_attribute_03=>'information'
,p_attribute_04=>'fa-info-circle'
,p_da_action_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(282345643207038097)
,p_name=>'BTN_STATUS_PREMARKETING'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(282344653657038087)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(282345671290038098)
,p_event_id=>wwv_flow_imp.id(282345643207038097)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>unistr('Soll der Status des Vermarktungsclusters &P5_VC_NAME. (&P5_VC_STATUS_DISP.) auf <b>PreMarketing</b> ge\00E4ndert werden?')
,p_attribute_02=>'Statuswechsel'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-question'
,p_attribute_06=>unistr('Ja, \00C4nderung durchf\00FChren')
,p_attribute_07=>'Nein'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(282346310690038104)
,p_event_id=>wwv_flow_imp.id(282345643207038097)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'STATUS_PREMARKETING'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(282345823696038099)
,p_name=>'BTN_STATUS_UNDERCONSTRUCT'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(282344717221038088)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(282345868279038100)
,p_event_id=>wwv_flow_imp.id(282345823696038099)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>unistr('Soll der Status des Vermarktungsclusters &P5_VC_NAME. (&P5_VC_STATUS_DISP.) auf <b>UnderConstruction</b> ge\00E4ndert werden?')
,p_attribute_02=>'Statuswechsel'
,p_attribute_03=>'warning'
,p_attribute_04=>'fa-question'
,p_attribute_06=>unistr('Ja, \00C4nderung durchf\00FChren')
,p_attribute_07=>'Nein'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(282346177107038103)
,p_event_id=>wwv_flow_imp.id(282345823696038099)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'STATUS_UNDERCONSTRUCTION'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(238022623726361553)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(245702010317656276)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Vermarktungscluster Details - IG - Save Interactive Grid Data'
,p_attribute_01=>'PLSQL_CODE'
,p_attribute_04=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    case :APEX$ROW_STATUS',
'    when ''C'' then',
'NULL;',
'    when ''U'' then',
'NULL;',
'    when ''D'' then',
'        pck_vermarktungsclstr_obj_dml.p_delete(pin_vco_lfd_nr => :VCO_LFD_NR);',
'   end case;',
'end;        '))
,p_attribute_05=>'N'
,p_attribute_06=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>73106762636278877
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(282346660322038107)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_STATUS_PREMARKETING'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_update_status(',
'    pin_vc_lfd_nr  => :P5_VC_ID',
'  , piv_status_alt => :P5_VC_STATUS',
'  , piv_status_neu => PCK_VERMARKTUNGSCLUSTER.VC_STATUS_PREMARKETING',
'  , piv_username   => :APP_USER',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'STATUS_PREMARKETING'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>unistr('Der Status des Vermarktungsclusters wurde auf "PreMarketing" ge\00E4ndert.')
,p_internal_uid=>117430799231955431
,p_process_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(282346378236038105)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_STATUS_UNDERCONSTRUCT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_update_status(',
'    pin_vc_lfd_nr  => :P5_VC_ID',
'  , piv_status_alt => :P5_VC_STATUS',
'  , piv_status_neu => PCK_VERMARKTUNGSCLUSTER.VC_STATUS_UNDERCONSTRUCTION',
'  , piv_username   => :APP_USER',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'STATUS_UNDERCONSTRUCTION'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_process_success_message=>unistr('Der Status des Vermarktungsclusters wurde auf "UnderConstruction" ge\00E4ndert.')
,p_internal_uid=>117430517145955429
,p_process_comment=>'@ticket FTTH-1787'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(282345018003038091)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Vermarktungscluster-Daten laden'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT bezeichnung',
'     , status',
'     , PCK_VERMARKTUNGSCLUSTER.fv_vc_status_display(status)',
'     , REPLACE(PCK_VERMARKTUNGSCLUSTER.fv_vc_folgestatus(piv_aktueller_status => status), status) -- der aktuelle Status soll hier nicht enhalten sein',
'     , WHOLEBUY',
'  INTO :P5_VC_NAME, :P5_VC_STATUS, :P5_VC_STATUS_DISP, :P5_VC_FOLGESTATUS, :P5_WHOLEBUY',
'  FROM VERMARKTUNGSCLUSTER',
' WHERE vc_lfd_nr = :P5_VC_ID;',
'',
'-- @ticket FTTH-2901:',
'IF :P5_WHOLEBUY IS NOT NULL THEN',
'    SELECT singular',
'      INTO :P5_WHOLEBUY_DISPLAY',
'      FROM enum',
'     WHERE domain = ''WHOLEBUY_PARTNER''',
'       AND kontext = ''FTTH''',
'       AND sprache = ''*''',
'       AND key = :P5_WHOLEBUY;',
'END IF;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P5_VC_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>117429156912955415
,p_process_comment=>'@ticket FTTH-1787, @ticket FTTH-2901'
);
wwv_flow_imp.component_end;
end;
/
