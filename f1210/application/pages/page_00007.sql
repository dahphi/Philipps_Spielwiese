prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_name=>unistr('Objekte hinzuf\00FCgen')
,p_alias=>unistr('OBJEKTE-HINZUF\00DCGEN')
,p_step_title=>unistr('Objekte hinzuf\00FCgen')
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.a-GV-frozen--startLast {',
'    border-right-width: var(--a-gv-frozen-last-border-width,2px);',
'    border-width: thin;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(237818891602052119)
,p_plug_name=>'Adressen'
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(237818964593052120)
,p_plug_name=>'Adressen IG'
,p_region_name=>'ADRESSEN_IG'
,p_parent_plug_id=>wwv_flow_imp.id(237818891602052119)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'return q''[ SELECT gebiet,typ,id,ort,plz,str,hnr,hnr_zus,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,bereits_zugeordnet,termin,ausbaustatus,bereits_zugeordnet_cluster',
'',
'FROM (',
'    SELECT gebiet,typ,id,ort,plz,str,hnr,hnr_zus,haus_lfd_nr,we_ges,dnsttp_bez,gee_status, gee_erteilt_am,bereits_zugeordnet,termin,ausbaustatus,bereits_zugeordnet_cluster, dense_rank () over (PARTITION BY haus_lfd_nr ORDER BY x DESC) dr',
'    FROM (',
'    SELECT 1 x, g.gebiet, ',
'        g.typ, ',
'        g.id,',
'        p.plz_oname ort, ',
'        p.plz_plz plz, ',
'        s.str_name46 str, ',
'        h.haus_hnr hnr, ',
'        h.haus_hnr_zus hnr_zus,',
'        h.haus_lfd_nr haus_lfd_nr,',
'        h.haus_we_ges we_ges,',
'        tdt.dnsttp_bez dnsttp_bez, ',
'        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, ',
'        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,',
'        case when vco.vc_lfd_nr is not null then 1 else 0 end  bereits_zugeordnet,',
'        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr )  bereits_zugeordnet_cluster,        ',
'        hast.has_termin termin,',
'        hast.has_ausbau_status ausbaustatus',
'    FROM strav.haus h',
'        INNER JOIN strav.stra_db s ON s.str_lfd_nr = h.str_lfd_nr',
'        INNER JOIN strav.plz_da p ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort',
'        LEFT OUTER JOIN  strav.haus_gebiet hg ON hg.haus_lfd_nr = h.haus_lfd_nr ',
'        LEFT OUTER JOIN  strav.gebiet g ON g.id = hg.gebiet_id',
'        --INNER JOIN  strav.haus_gebiet hg ON hg.haus_lfd_nr = h.haus_lfd_nr ',
'        --INNER JOIN  strav.gebiet g ON g.id = hg.gebiet_id',
'        LEFT OUTER JOIN strav.haus_daten hd ON hd.haus_lfd_nr = h.haus_lfd_nr',
'        LEFT OUTER JOIN tab_dienst_typ tdt ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr',
'        LEFT OUTER JOIN  VERMARKTUNGSCLUSTER_OBJEKT  vco on vco.haus_lfd_nr = h.haus_lfD_nr ',
'        left outer join strav.haus_ausbau_status hast on hast.haus_lfd_nr = h.haus_lfd_nr',
'        WHERE             ',
'              g.id = nvl(:P7_SEARCH_GEBIET,g.id)',
'          OR :P7_SEARCH_ALL IS NOT NULL ',
'          OR g.typ = nvl(:P7_SEARCH_TYP,g.typ)                    ',
'',
'UNION ALL        ',
'        ',
'         SELECT 2 x, ag.NAME gebiet, ',
'        t.ausbgbttp_bez typ, ',
'        ag.id,',
'        p.plz_oname ort, ',
'        p.plz_plz plz, ',
'        s.str_name46 str, ',
'        h.haus_hnr hnr, ',
'        h.haus_hnr_zus hnr_zus,',
'        h.haus_lfd_nr haus_lfd_nr,',
'        h.haus_we_ges we_ges,',
'        tdt.dnsttp_bez dnsttp_bez, ',
'        strav.pck_ems_query.fv_gee_status(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_status, ',
'        strav.pck_ems_query.fd_gee_erteilt_am(pin_haus_lfd_nr=> h.haus_lfd_nr) gee_erteilt_am,',
'        case when vco.vc_lfd_nr is not null then 1 else 0 end  bereits_zugeordnet,',
'        (select bezeichnung from vermarktungscluster where vc_lfd_nr = vco.vc_lfd_nr )  bereits_zugeordnet_cluster,        ',
'        hast.has_termin termin,',
'        hast.has_ausbau_status ausbaustatus',
'    FROM strav.haus h',
'        INNER JOIN strav.stra_db s ON s.str_lfd_nr = h.str_lfd_nr',
'        INNER JOIN strav.plz_da p ON p.plz_plz = s.str_plz AND p.plz_alort = s.str_alort',
'        LEFT OUTER JOIN  SW_AUSBAUGEBIET_OBJEKT@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ago ON ago.haus_lfd_nr = h.haus_lfd_nr ',
'        LEFT OUTER JOIN  SW_AUSBAUGEBIET@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ag ON ag.id = ago.id',
'        LEFT OUTER JOIN tab_ausbaugebiet_typ@GESWP.NETCOLOGNE.INTERN@SW$ADMIN t ON t.ausbgbttp_id = ag.ausbgbttp_id ',
'        --INNER JOIN  strav.haus_gebiet hg ON hg.haus_lfd_nr = h.haus_lfd_nr ',
'        --INNER JOIN  strav.gebiet g ON g.id = hg.gebiet_id',
'        LEFT OUTER JOIN strav.haus_daten hd ON hd.haus_lfd_nr = h.haus_lfd_nr',
'        LEFT OUTER JOIN tab_dienst_typ tdt ON tdt.dnsttp_lfd_nr = hd.hsb_dnsttp_lfd_nr',
'        LEFT OUTER JOIN  VERMARKTUNGSCLUSTER_OBJEKT  vco on vco.haus_lfd_nr = h.haus_lfD_nr ',
'        left outer join strav.haus_ausbau_status hast on hast.haus_lfd_nr = h.haus_lfd_nr',
'        WHERE             ',
'             ag.id = nvl(:P7_SEARCH_GEBIET,ag.id)',
'          OR :P7_SEARCH_ALL IS NOT NULL ',
'          OR t.ausbgbttp_bez = nvl(:P7_SEARCH_TYP,t.ausbgbttp_bez)   ',
'',
'        )',
'        WHERE 1=1 ',
'    ',
']''',
'',
'			',
'|| pck_strav_query.fcl_adress_where_query',
'            (',
'                piv_search_all   => :P7_SEARCH_ALL',
'              , piv_do_search    => :P7_DO_SEARCH --''Y''',
'              , piv_alias        => NULL',
'            )',
'',
'',
'             || '')',
'          WHERE 1=1',
'          AND dr =1 '';'))
,p_plug_source_type=>'NATIVE_IG'
,p_ajax_items_to_submit=>'P7_SEARCH_GEBIET,P7_SEARCH_ALL,P7_SEARCH_TYP,P7_DO_SEARCH,P7_VC_ID'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Adressen IG'
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
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(236216238425552354)
,p_heading=>'GEE'
);
wwv_flow_imp_page.create_region_column_group(
 p_id=>wwv_flow_imp.id(236216303940552355)
,p_heading=>'Netzbau'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(236216494087552356)
,p_name=>'BEREITS_ZUGEORDNET_CLUSTER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BEREITS_ZUGEORDNET_CLUSTER'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Vermarktungscluster'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
 p_id=>wwv_flow_imp.id(237819520112052126)
,p_name=>'GEBIET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEBIET'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Gebiet'
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
 p_id=>wwv_flow_imp.id(237819640472052127)
,p_name=>'TYP'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TYP'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Typ'
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
 p_id=>wwv_flow_imp.id(237819779380052128)
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
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(237819861494052129)
,p_name=>'PLZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PLZ'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Plz'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
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
 p_id=>wwv_flow_imp.id(237819945579052130)
,p_name=>'STR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STR'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Str'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(237820073020052131)
,p_name=>'HNR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Hnr'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>90
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
 p_id=>wwv_flow_imp.id(237820193730052132)
,p_name=>'HNR_ZUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HNR_ZUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Hnr Zus'
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
 p_id=>wwv_flow_imp.id(237820238300052133)
,p_name=>'HAUS_LFD_NR'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'HAUS_LFD_NR'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Haus Lfd Nr'
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
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(237820324709052134)
,p_name=>'WE_GES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'WE_GES'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'WE Gesamt'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>110
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
 p_id=>wwv_flow_imp.id(237820404719052135)
,p_name=>'DNSTTP_BEZ'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DNSTTP_BEZ'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Technologie'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>25
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'STATIC'
,p_filter_lov_query=>'FTTH,G.fast,FTTB'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(237820518191052136)
,p_name=>'GEE_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_STATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>' Status'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>130
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216238425552354)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'STATIC'
,p_filter_lov_query=>'offen,erledigt,verweigert'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(237820676593052137)
,p_name=>'GEE_ERTEILT_AM'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'GEE_ERTEILT_AM'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'erteilt am '
,p_heading_alignment=>'CENTER'
,p_display_sequence=>140
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216238425552354)
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
 p_id=>wwv_flow_imp.id(237821287139052143)
,p_name=>'ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>150
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
 p_id=>wwv_flow_imp.id(237821837121052149)
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
 p_id=>wwv_flow_imp.id(238022385453361550)
,p_name=>'BEREITS_ZUGEORDNET'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BEREITS_ZUGEORDNET'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Bereits Zugeordnet'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'STATIC'
,p_lov_source=>'STATIC2:Nein;0,Ja;1'
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>'0'
,p_lov_null_value=>'0'
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
 p_id=>wwv_flow_imp.id(238196998621208043)
,p_name=>'TERMIN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TERMIN'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Termin'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>170
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216303940552355)
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
 p_id=>wwv_flow_imp.id(238197179850208044)
,p_name=>'AUSBAUSTATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AUSBAUSTATUS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading=>'Ausbaustatus'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>180
,p_value_alignment=>'CENTER'
,p_group_id=>wwv_flow_imp.id(236216303940552355)
,p_use_group_for=>'BOTH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
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
 p_id=>wwv_flow_imp.id(237819075660052121)
,p_internal_uid=>11370480802950205
,p_is_editable=>true
,p_lost_update_check_type=>'VALUES'
,p_submit_checked_rows=>false
,p_lazy_loading=>true
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
,p_download_formats=>'CSV:XLSX'
,p_enable_mail_download=>true
,p_csv_separator=>';'
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(237829774416406922)
,p_interactive_grid_id=>wwv_flow_imp.id(237819075660052121)
,p_static_id=>'113812'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_rows_per_page=>100000
,p_show_row_number=>false
,p_settings_area_expanded=>false
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(237829963446406924)
,p_report_id=>wwv_flow_imp.id(237829774416406922)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(236506380716901816)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(236216494087552356)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>137.48899999999998
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237832663824421363)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(237819520112052126)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>175
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237833569653421366)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(237819640472052127)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>75.219
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237834450447421370)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(237819779380052128)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>94.22000000000003
,p_sort_order=>3
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237835347206421373)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(237819861494052129)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>61
,p_sort_order=>2
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237836285292421375)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(237819945579052130)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>182.0199
,p_sort_order=>4
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237837120766421378)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(237820073020052131)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>64
,p_sort_order=>5
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237838059279421380)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(237820193730052132)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>61.9915
,p_sort_order=>6
,p_sort_direction=>'ASC'
,p_sort_nulls=>'LAST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237838976513421382)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(237820238300052133)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>74.989
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237839872703421384)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(237820324709052134)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>76.9858
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237840767816421386)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(237820404719052135)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>86.009
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237841663978421388)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(237820518191052136)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>83.989
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237842540809421390)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(237820676593052137)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>91
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(237854091320634685)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(237821287139052143)
,p_is_visible=>false
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238061836736552161)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(238022385453361550)
,p_is_visible=>false
,p_is_frozen=>false
,p_sort_order=>1
,p_break_order=>5
,p_break_is_enabled=>true
,p_break_sort_direction=>'ASC'
,p_break_sort_nulls=>'LAST'
,p_sort_direction=>'DESC'
,p_sort_nulls=>'FIRST'
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238822521856249228)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(238196998621208043)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(238824396261249232)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(238197179850208044)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>100
);
wwv_flow_imp_page.create_ig_report_highlight(
 p_id=>wwv_flow_imp.id(226448969530101917)
,p_view_id=>wwv_flow_imp.id(237829963446406924)
,p_execution_seq=>5
,p_name=>'bereits zugeordnet'
,p_background_color=>'#f9f9f9'
,p_text_color=>'#a4a4a4'
,p_condition_type=>'COLUMN'
,p_condition_column_id=>wwv_flow_imp.id(238022385453361550)
,p_condition_operator=>'EQ'
,p_condition_is_case_sensitive=>false
,p_condition_expression=>'Ja'
,p_is_enabled=>true
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(237819183198052122)
,p_plug_name=>'P7_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(237823215694052163)
,p_plug_name=>'Hilfe'
,p_region_template_options=>'#DEFAULT#:js-dialog-size720x480'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236551834480961953)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source=>'htp.p(pck_strav_query.fcl_adress_where_query_help)'
,p_plug_source_type=>'NATIVE_PLSQL'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(238195414606208027)
,p_plug_name=>'Collection'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(238195500703208028)
,p_name=>'Collection Adressen Neu'
,p_parent_plug_id=>wwv_flow_imp.id(238195414606208027)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>'select n001 ,c001 from apex_collections where collection_name = ''ADRESSEN_NEU'' '
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236583898978961966)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'ROW_RANGES_WITH_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(238195661610208029)
,p_query_column_id=>1
,p_column_alias=>'N001'
,p_column_display_sequence=>10
,p_column_heading=>'N001'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(238196012573208033)
,p_query_column_id=>2
,p_column_alias=>'C001'
,p_column_display_sequence=>20
,p_column_heading=>'C001'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(245716592423858365)
,p_plug_name=>'Ausbaugebiet Suche'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(249194757528006034)
,p_plug_name=>'Adresse'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(260161272699763559)
,p_plug_name=>unistr('Vermarktungscluster <b>&P7_VC_NAME.</b> - Objekte hinzuf\00FCgen')
,p_icon_css_classes=>'app-icon'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236547199245961951)
,p_plug_display_sequence=>80
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(236499478762961929)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(236623521283961985)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(237821313804052144)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(249194757528006034)
,p_button_name=>'P7_BTN_SEARCH'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--stretch:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Suche'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(237822895015052160)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(249194757528006034)
,p_button_name=>'P7_BTN_SEARCH_INFO'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Search Info'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(202201002392072194)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(245716592423858365)
,p_button_name=>'P7_BTN_KOMPLETTES_GEBIET'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'komplettes Gebiet zuordnen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-badge-check'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(238195723336208030)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(238195500703208028)
,p_button_name=>'P7_BTN_COLL_REFRESH_ADRESSEN_NEU'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'Refresh Adressen Neu'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(238196101399208034)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(260161272699763559)
,p_button_name=>'P7_BTN_SPEICHERN'
,p_button_static_id=>'P7_BTN_SPEICHERN_2'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Speichern'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(237817417688046531)
,p_name=>'P7_SEARCH_GEBIET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(245716592423858365)
,p_prompt=>'Ausbaugebiet'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select d,r',
'from (',
'SELECT gebiet || '' ('' || typ || '')'' d, id r',
'  FROM strav.gebiet',
'',
'union',
'SELECT name || '' ('' || ausbgbttp_bez || '')'' d, id r',
' FROM SW_AUSBAUGEBIET@GESWP.NETCOLOGNE.INTERN@SW$ADMIN a',
'INNER JOIN tab_ausbaugebiet_typ@GESWP.NETCOLOGNE.INTERN@SW$ADMIN b ON b.ausbgbttp_id = a.ausbgbttp_id AND b.ausbgbttp_bez = ''Administration''',
'',
') '))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-'
,p_lov_null_value=>'0'
,p_cHeight=>1
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(237817891691046532)
,p_name=>'P7_SEARCH_TYP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(245716592423858365)
,p_prompt=>'Ausbaugebiet Typ'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT distinct typ d, typ r',
'  FROM strav.gebiet',
unistr('  where typ not like ''\00DCbergeordneter Name'''),
'union',
'SELECT distinct b.ausbgbttp_bez d, b.ausbgbttp_bez r',
' FROM tab_ausbaugebiet_typ@GESWP.NETCOLOGNE.INTERN@SW$ADMIN b ',
' where b.ausbgbttp_bez = ''Administration''',
'  --ORDER BY typ'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-'
,p_lov_null_value=>'0'
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
 p_id=>wwv_flow_imp.id(237819243839052123)
,p_name=>'P7_SEARCH_ALL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(249194757528006034)
,p_prompt=>'Adresssuche'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'Y',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(237819296285052124)
,p_name=>'P7_DO_SEARCH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(249194757528006034)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238021244606361539)
,p_name=>'P7_VC_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(237819183198052122)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238600976321176214)
,p_name=>'P7_VC_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(237819183198052122)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(238196578176208038)
,p_computation_sequence=>10
,p_computation_item=>'P7_VC_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select bezeichnung ',
'  from VERMARKTUNGSCLUSTER',
'  where vc_lfd_nr =  :P7_VC_ID'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237820757207052138)
,p_name=>'Suche nach Gebiet'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_SEARCH_GEBIET'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237820860396052139)
,p_event_id=>wwv_flow_imp.id(237820757207052138)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(237818964593052120)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237821097707052142)
,p_event_id=>wwv_flow_imp.id(237820757207052138)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'console.log($v(''P7_SEARCH_GEBIET''));'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237820967222052140)
,p_name=>'Suche nach Typ'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_SEARCH_TYP'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237821072353052141)
,p_event_id=>wwv_flow_imp.id(237820967222052140)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(237818964593052120)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237821457312052145)
,p_name=>'Suche Adresse'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(237821313804052144)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237821574465052146)
,p_event_id=>wwv_flow_imp.id(237821457312052145)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P7_DO_SEARCH := ''Y'';'
,p_attribute_03=>'P7_DO_SEARCH'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237821617266052147)
,p_event_id=>wwv_flow_imp.id(237821457312052145)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(237818964593052120)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237822089937052151)
,p_name=>'Collection setzen'
,p_event_sequence=>40
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(237818964593052120)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|interactivegridselectionchange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237822113722052152)
,p_event_id=>wwv_flow_imp.id(237822089937052151)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF APEX_COLLECTION.collection_exists(p_collection_name => ''ADRESSEN_NEU'')',
'THEN ',
'--APEX_COLLECTION.DELETE_COLLECTION(''ADRESSEN_NEU'');',
'APEX_COLLECTION.TRUNCATE_COLLECTION(''ADRESSEN_NEU'');',
'END IF;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237822731744052158)
,p_name=>'Suche aktivieren'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237822855986052159)
,p_event_id=>wwv_flow_imp.id(237822731744052158)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_DO_SEARCH'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237823018452052161)
,p_name=>'Search Hilfe anzeigen'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(237822895015052160)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(237823183857052162)
,p_event_id=>wwv_flow_imp.id(237823018452052161)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(237823215694052163)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238023261096361559)
,p_name=>unistr('Collection l\00F6schen')
,p_event_sequence=>70
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238023347358361560)
,p_event_id=>wwv_flow_imp.id(238023261096361559)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF APEX_COLLECTION.collection_exists(p_collection_name => ''ADRESSEN_NEU'')',
'THEN ',
'--APEX_COLLECTION.DELETE_COLLECTION(''ADRESSEN_NEU'');',
'APEX_COLLECTION.TRUNCATE_COLLECTION(''ADRESSEN_NEU'');',
'END IF;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238195869926208031)
,p_name=>'New'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(238195723336208030)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238195918902208032)
,p_event_id=>wwv_flow_imp.id(238195869926208031)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(238195500703208028)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238196275039208035)
,p_name=>'Auswahl in Collection speichern'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(238196101399208034)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238196313887208036)
,p_event_id=>wwv_flow_imp.id(238196275039208035)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var i, anzahl, anzGes,records, record, $HausLfdNr,$GeeStatus,$BereitsZugeordnet, model, anz,',
'                view = apex.region("ADRESSEN_IG").widget().interactiveGrid("getCurrentView");',
'            //console.log(view);',
'            // editable view',
'            if ( view.supports.edit )',
'                {',
'                    model = view.model;',
'                    records = view.getSelectedRecords();',
unistr('                    //console.log(''Anazhl an S\00E4tzen : '' + records.length);'),
'                    if ( records.length > 0 )',
'                        {',
'                            for ( i = 0; i < records.length; i++)',
'                                {',
'                                    record = records[i];',
'                                    $BereitsZugeordnet = (model.getValue(record, "BEREITS_ZUGEORDNET"));',
'                                    //console.log($BereitsZugeordnet);',
'                                   // console.log(parseFloat($BereitsZugeordnet.v));',
'                                    if (parseFloat($BereitsZugeordnet.v) != 1)',
'                                    {',
'                                  ',
unistr('                                    //anz = ''Adressen wurden ausgew\00E4hlt.<br>Speichern nicht vergessen!'';'),
'                                    $HausLfdNr = parseFloat(model.getValue(record, "HAUS_LFD_NR"));',
'                                     //console.log($HausLfdNr);',
'                                    $GeeStatus = (model.getValue(record, "GEE_STATUS"));',
'                                        apex.server.process ("asp_adressen_hinzufuegen", ',
'                                                            {',
'                                                            x01:$HausLfdNr',
'                                                            ,x02:$GeeStatus',
'                                                            //x02:$EmpName',
'                                                            },',
'                                                            {tpye: ''GET'', dataType: ''text'', //loadingIndicator: "#P7_BTN_SPEICHERN_2",',
'                                                                                            success: function( text ) ',
'                                                                                            { //   apex.message.showPageSuccess(anz);',
'                                                                                               ',
'                                                                                            //apex.message.showPageSuccess($HausLfdNr);',
'                                                                                            }, error: function(request, status, error) {',
'                                                                                            alert(request.responseText);',
'                                                                                            }',
'                                                            });',
'                                             ',
'                                    }',
'                                }',
'                        }',
'',
'                    //console.log(''Fertig'');',
'                    //apex.submit( ''SPEICHERN'' );',
'                }'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238196475829208037)
,p_event_id=>wwv_flow_imp.id(238196275039208035)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'SPEICHERN'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(237728969737320466)
,p_name=>'Max Rows setzen'
,p_event_sequence=>100
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(250444728948289317)
,p_event_id=>wwv_flow_imp.id(237728969737320466)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var actions = apex.region("ADRESSEN_IG").call("getActions");',
'var crpp = actions.lookup("change-rows-per-page");',
'',
'crpp.choices[1] = { label: "100000", value: 100000 };',
'',
'actions.update("change-rows-per-page");'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(202201117086072195)
,p_name=>'komplettes Gebiet zuordnen'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(202201002392072194)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202201205848072196)
,p_event_id=>wwv_flow_imp.id(202201117086072195)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    pior_vermarktungscluster_obj  vermarktungscluster_objekt%ROWTYPE;',
'',
'',
'begin',
' --raise_application_error(-20001,pior_vertriebscluster_objekt.haus_lfD_nr);',
'',
'    --for item in ( select haus_lfd_nr from strav.haus_gebiet hg where gebiet_id = :P7_SEARCH_GEBIET and haus_lfd_nr not in (select vmco.haus_lfd_nr from vermarktungscluster_objekt vmco where vmco.vc_lfd_nr = :P7_VC_ID) )',
'    for item in ( select haus_lfd_nr from strav.haus_gebiet hg where gebiet_id = :P7_SEARCH_GEBIET and haus_lfd_nr not in (select vmco.haus_lfd_nr from vermarktungscluster_objekt vmco ) )',
'    loop',
'        pior_vermarktungscluster_obj.VCO_LFD_NR := NULL;',
'        pior_vermarktungscluster_obj.VC_LFD_NR := :P7_VC_ID;',
'        pior_vermarktungscluster_obj.haus_lfD_nr := item.haus_lfd_nr;',
'',
'        pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => pior_vermarktungscluster_obj);',
'    --    raise_application_error(-20001,pior_vertriebscluster_objekt.haus_lfD_nr);',
'/*',
'        APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER_DETAILS'',',
'        p_n001            => :P7_VC_ID,',
'        p_n002            => item.n001 ,',
'        p_c001            => item.c001);',
'*/',
'',
'    end loop;',
'',
unistr('    -- die neuen zus\00E4tzlichen "Administration" Gebiete zuordnen -- wenn ausgew\00E4hlt'),
'    for item in ( ',
'        SELECT ago.haus_lfd_nr',
'        FROM ',
'                   SW_AUSBAUGEBIET_OBJEKT@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ago ',
'        INNER JOIN  SW_AUSBAUGEBIET@GESWP.NETCOLOGNE.INTERN@SW$ADMIN ag ON ag.id = ago.id',
'        WHERE ag.id = :P7_SEARCH_GEBIET',
'        --and ago.haus_lfd_nr not in (select vmco.haus_lfd_nr from vermarktungscluster_objekt vmco where vmco.vc_lfd_nr = :P7_VC_ID)',
'        and ago.haus_lfd_nr not in (select vmco.haus_lfd_nr from vermarktungscluster_objekt vmco )',
'     )',
'    loop',
'        pior_vermarktungscluster_obj.VCO_LFD_NR := NULL;',
'        pior_vermarktungscluster_obj.VC_LFD_NR := :P7_VC_ID;',
'        pior_vermarktungscluster_obj.haus_lfD_nr := item.haus_lfd_nr;',
'',
'        pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => pior_vermarktungscluster_obj);',
'    end loop;',
'',
'end;'))
,p_attribute_02=>'P7_SEARCH_GEBIET'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(202201287991072197)
,p_event_id=>wwv_flow_imp.id(202201117086072195)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(237818964593052120)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(237821918811052150)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(237818964593052120)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Adressen IG - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_internal_uid=>72906057720969474
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(237822203761052153)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'asp_adressen_hinzufuegen'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    pior_vermarktungscluster_obj  vermarktungscluster_objekt%ROWTYPE;',
'',
'    vnAnzMember             number;',
'begin',
'/*',
'    if not apex_collection.collection_exists(p_collection_name => ''ADRESSEN_NEU'') then',
'        APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(''ADRESSEN_NEU'');',
'    end if;',
'  */ ',
'  /*',
'        pior_vermarktungscluster_obj.VCO_LFD_NR := NULL;',
'        pior_vermarktungscluster_obj.VC_LFD_NR := :P7_VC_ID;',
'        pior_vermarktungscluster_obj.haus_lfD_nr := apex_application.g_x01;',
'',
'        pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => pior_vermarktungscluster_obj);',
'',
'*/  ',
'    select count(1) into vnAnzMember from apex_collections where collection_name = ''ADRESSEN_NEU'' and n001 = apex_application.g_x01;',
'    if (vnAnzMember) = 0',
'    then ',
'    apex_collection.add_member (p_collection_name => ''ADRESSEN_NEU'',',
'                                p_n001            => apex_application.g_x01,',
'                                p_c001            => apex_application.g_x02',
'                               );',
'    end if;',
'',
'',
'/*',
'            APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER_DETAILS'',',
'        p_n001            => :P7_VC_ID,',
'        p_n002            => apex_application.g_x01 ,',
'        p_c001            => apex_application.g_x02);',
'  */      ',
'',
'exception',
'when others then',
'',
unistr('  -- ab und zu tritt ein Fehler auf, dass nicht alle ausgew\00E4hlten Elemente in die Collection \00FCberf\00FChrt werden'),
unistr('  -- dazu habe ich keine L\00F6sung gefunden, auch nicht im Internet'),
'  -- https://community.oracle.com/tech/developers/discussion/524490/unusual-primary-key-constraint-violation',
'  -- https://tedstruik-oracle.nl/ords/f?p=25384:1110::::::',
'  ',
'  -- es scheint ein zeitliches Problem zu sein',
unistr('  -- daher die L\00F6sung es im Fehlerfall einfach nochmal zu probieren, bisher l\00F6st es das Problem'),
'       select count(1) into vnAnzMember from apex_collections where collection_name = ''ADRESSEN_NEU'' and n001 = apex_application.g_x01;',
'    if (vnAnzMember) = 0',
'    then ',
'    apex_collection.add_member (p_collection_name => ''ADRESSEN_NEU'',',
'                                p_n001            => apex_application.g_x01,',
'                                p_c001            => apex_application.g_x02',
'                               );',
'        end if;',
'end;',
'',
'',
'',
'',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>72906342670969477
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(238021498324361542)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Daten speichern'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    pior_vermarktungscluster_obj  vermarktungscluster_objekt%ROWTYPE;',
'',
'',
'begin',
' --raise_application_error(-20001,pior_vertriebscluster_objekt.haus_lfD_nr);',
'',
'    for item in ( select n001,c001 from apex_collections where collection_name = ''ADRESSEN_NEU'')',
'    loop',
'        pior_vermarktungscluster_obj.VCO_LFD_NR := NULL;',
'        pior_vermarktungscluster_obj.VC_LFD_NR := :P7_VC_ID;',
'        pior_vermarktungscluster_obj.haus_lfD_nr := item.n001;',
'',
'        pck_vermarktungsclstr_obj_dml.p_insert(pior_vermarktungscluster_obj => pior_vermarktungscluster_obj);',
'    --    raise_application_error(-20001,pior_vertriebscluster_objekt.haus_lfD_nr);',
'/*',
'        APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''VERTRIEBSCLUSTER_DETAILS'',',
'        p_n001            => :P7_VC_ID,',
'        p_n002            => item.n001 ,',
'        p_c001            => item.c001);',
'*/',
'',
'    end loop;',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'SPEICHERN'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>73105637234278866
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(238021643712361543)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Dialog schliessen'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_internal_uid=>73105782622278867
);
wwv_flow_imp.component_end;
end;
/
