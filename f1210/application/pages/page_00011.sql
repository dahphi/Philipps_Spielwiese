prompt --application/pages/page_00011
begin
--   Manifest
--     PAGE: 00011
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
 p_id=>11
,p_name=>'Listenimport'
,p_alias=>'LISTENIMPORT'
,p_step_title=>'Listenimport'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'div.datei{margin:1em 0;padding-bottom:5px;border-bottom:1px solid #CCC}',
'div.datei>span.dateiname{font-weight:bold}',
'',
'#IR_GEPLANTE_AKTIONEN td[headers="STATUS"] input:checked + label[for$="Y"] {',
'  background-color:#0A0',
'}',
'#IR_GEPLANTE_AKTIONEN td[headers="STATUS"] input:checked + label[for$="N"] {',
'  background-color:#A00',
'}',
'',
'div.step-infobox{',
'  margin:3em 200px 0 200px;text-align:center;padding:2em;border:3px dashed #6e8598',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203611647480478410)
,p_plug_name=>'Wizard-Regionen'
,p_region_template_options=>'#DEFAULT#:margin-top-lg'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>10
,p_plug_display_column=>2
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203611746355478411)
,p_plug_name=>'Schritt 1 von 5'
,p_parent_plug_id=>wwv_flow_imp.id(203611647480478410)
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_STEP'
,p_plug_display_when_cond2=>'1'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203611819011478412)
,p_plug_name=>'Schritt 2 von 5'
,p_parent_plug_id=>wwv_flow_imp.id(203611647480478410)
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_STEP'
,p_plug_display_when_cond2=>'2'
,p_plug_header=>'<div class="datei">Datei: <span class="dateiname">&P11_FILE_NAME.</span></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(205282753481795014)
,p_plug_name=>'Relevante Spalte bestimmen'
,p_parent_plug_id=>wwv_flow_imp.id(203611819011478412)
,p_region_template_options=>'#DEFAULT#:i-h320:t-Region--scrollBody:margin-top-md'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>50
,p_plug_grid_column_span=>6
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(205282803715795015)
,p_plug_name=>'Aktion festlegen'
,p_parent_plug_id=>wwv_flow_imp.id(203611819011478412)
,p_region_template_options=>'#DEFAULT#:i-h320:t-Region--scrollBody:margin-top-md'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>80
,p_plug_new_grid_row=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203611900182478413)
,p_plug_name=>'Schritt 3 von 5'
,p_parent_plug_id=>wwv_flow_imp.id(203611647480478410)
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<p>Der Import bewirkt die folgenden Aktionen. Durch \00C4ndern der Spalte "Aktion ausf\00FChren?" zu "nein" k\00F6nnen Sie die Verarbeitung bestimmter Zeilen ausschlie\00DFen<br/>'),
unistr('(um s\00E4mtliche geplanten und ausgeschlossenen Aktionen zu \00FCberblicken, w\00E4hlen Sie bitte "1. Hauptbericht" aus und entfernen Sie alle Filter, die Sie hinzugef\00FCgt haben).</p>')))
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_STEP'
,p_plug_display_when_cond2=>'3'
,p_plug_header=>'<div class="datei">Datei: <span class="dateiname">&P11_FILE_NAME.</span></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(205564942864360016)
,p_plug_name=>'IR_GEPLANTE_AKTIONEN'
,p_region_name=>'IR_GEPLANTE_AKTIONEN'
,p_parent_plug_id=>wwv_flow_imp.id(203611900182478413)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SEQ_ID,',
'       N001 AS ZEILENNUMMER_CSV,',
'       N002 AS GEPLANTE_AKTION,',
'       N005 AS PROBLEMKATEGORIE,',
unistr('       SIGN (N005) AS SCHWERWIEGEND, -- negativ: schwerwiegend, positiv: nur auff\00E4llig, NULL: OK'),
'       C001 AS HAUS_LFD_NR,',
'       C002 AS VMC_ALT,',
'       C003 AS VMC_NEU,',
'       C005 AS VALIDIERUNG,',
'       APEX_ITEM.SWITCH(',
'             p_idx        => SEQ_ID,',
'             p_value      => N003,',
'             p_on_value   => ''1'',',
'             p_on_label   => ''ja'',',
'             p_off_value  => ''0'',',
'             p_off_label  => ''nein'',',
'             p_item_id    => ''seq-'' || seq_id,',
'             p_item_label => NULL',
'       ) AS STATUS,',
'       N003 AS STATUS_AUSFUEHREN,',
'       NVL(C006, ''-'') AS ADRESSE,',
'       NVL(C007, ''-'') AS VMC_ALT_BEZEICHNUNG,',
'       NVL(C008, ''-'') AS VMC_NEU_BEZEICHNUNG,',
'       C011 AS STR,',
'       C012 AS NR,',
'       C013 AS ZUS,',
'       C014 AS PLZ,',
'       C015 AS ORT       ',
'  FROM APEX_COLLECTIONS C',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'IG_GEPLANTE_AKTIONEN'
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
,p_plug_comment=>unistr('Prim\00E4rschl\00FCssel f\00FCr s\00E4mtliche AJAX-Aktionen ist die SEQ_ID')
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(205940049470897790)
,p_max_row_count=>'1000000'
,p_allow_report_saving=>'N'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_LEFT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_control_break=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_show_download=>'N'
,p_show_help=>'N'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>41024188380815114
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940105906897791)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Seq Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940198450897792)
,p_db_column_name=>'ZEILENNUMMER_CSV'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'CSV-Zeile'
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
 p_id=>wwv_flow_imp.id(205940518718897795)
,p_db_column_name=>'HAUS_LFD_NR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'HAUS_LFD_NR'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940590046897796)
,p_db_column_name=>'VMC_ALT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'VC_LFD_NR bisher'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940307399897793)
,p_db_column_name=>'GEPLANTE_AKTION'
,p_display_order=>70
,p_column_identifier=>'C'
,p_column_label=>'Geplante Aktion'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_imp.id(206007217016494724)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940723859897797)
,p_db_column_name=>'VMC_NEU'
,p_display_order=>80
,p_column_identifier=>'G'
,p_column_label=>unistr('VC_LFD_NR zuk\00FCnftig')
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206134703969490778)
,p_db_column_name=>'PROBLEMKATEGORIE'
,p_display_order=>90
,p_column_identifier=>'S'
,p_column_label=>'Problemkategorie'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_imp.id(206161502645547475)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940929431897799)
,p_db_column_name=>'VALIDIERUNG'
,p_display_order=>100
,p_column_identifier=>'I'
,p_column_label=>unistr('Auff\00E4lligkeiten')
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205940803506897798)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'H'
,p_column_label=>unistr('Aktion ausf\00FChren?')
,p_allow_sorting=>'N'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_static_id=>'STATUS'
,p_use_as_row_header=>'N'
,p_column_comment=>unistr('Der Switch l\00E4sst sich leider nicht mittig ausrichten.')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205941385529897804)
,p_db_column_name=>'VMC_ALT_BEZEICHNUNG'
,p_display_order=>120
,p_column_identifier=>'J'
,p_column_label=>'Vermarktungscluster bisher'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205941524923897805)
,p_db_column_name=>'VMC_NEU_BEZEICHNUNG'
,p_display_order=>130
,p_column_identifier=>'K'
,p_column_label=>unistr('Vermarktungscluster zuk\00FCnftig')
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206134593612490777)
,p_db_column_name=>'ADRESSE'
,p_display_order=>140
,p_column_identifier=>'R'
,p_column_label=>'Adresse'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205943237663897822)
,p_db_column_name=>'STR'
,p_display_order=>150
,p_column_identifier=>'M'
,p_column_label=>unistr('Stra\00DFe')
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205943291066897823)
,p_db_column_name=>'NR'
,p_display_order=>160
,p_column_identifier=>'N'
,p_column_label=>'Nr.'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205943395894897824)
,p_db_column_name=>'ZUS'
,p_display_order=>170
,p_column_identifier=>'O'
,p_column_label=>'Zusatz'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205943558206897825)
,p_db_column_name=>'PLZ'
,p_display_order=>180
,p_column_identifier=>'P'
,p_column_label=>'PLZ'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205943641961897826)
,p_db_column_name=>'ORT'
,p_display_order=>190
,p_column_identifier=>'Q'
,p_column_label=>'Ort'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206139335187490824)
,p_db_column_name=>'STATUS_AUSFUEHREN'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Status Ausfuehren'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(211587076260690591)
,p_db_column_name=>'SCHWERWIEGEND'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>'Schwerwiegend'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(206022215191561644)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'HAUPTBERICHT'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:HAUS_LFD_NR:PLZ:ORT:STR:NR:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:PROBLEMKATEGORIE:VALIDIERUNG:STATUS'
,p_sort_column_1=>'SCHWERWIEGEND'
,p_sort_direction_1=>'ASC NULLS LAST'
,p_sort_column_2=>'ZEILENNUMMER_CSV'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214042411290858088)
,p_report_id=>wwv_flow_imp.id(206022215191561644)
,p_name=>'schwerwiegend'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#ffc0c0'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214042818979858088)
,p_report_id=>wwv_flow_imp.id(206022215191561644)
,p_name=>unistr('auff\00E4llig')
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#fff5ce'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(208789250065271836)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>unistr('Auff\00E4llige Konstellationen')
,p_report_seq=>10
,p_report_alias=>'AUFFAELLIGE_KONSTELLATIONEN'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:HAUS_LFD_NR:PLZ:ORT:STR:NR:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:PROBLEMKATEGORIE:VALIDIERUNG:STATUS'
,p_sort_column_1=>'ZEILENNUMMER_CSV'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214041451885850239)
,p_report_id=>wwv_flow_imp.id(208789250065271836)
,p_name=>'schwerwiegend'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#ffc0c0'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214041830610850239)
,p_report_id=>wwv_flow_imp.id(208789250065271836)
,p_name=>unistr('auff\00E4llig')
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#fff5ce'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214041017843850239)
,p_report_id=>wwv_flow_imp.id(208789250065271836)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'PROBLEMKATEGORIE'
,p_operator=>'is not null'
,p_condition_sql=>'"PROBLEMKATEGORIE" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(213839531986164374)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Von Ihnen ausgeschlossene Aktionen'
,p_report_seq=>10
,p_report_alias=>'AUSGESCHLOSSENE_AKTIONEN'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:HAUS_LFD_NR:PLZ:ORT:STR:NR:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:PROBLEMKATEGORIE:VALIDIERUNG:STATUS'
,p_sort_column_1=>'PROBLEMKATEGORIE'
,p_sort_direction_1=>'ASC NULLS LAST'
,p_sort_column_2=>'ZEILENNUMMER_CSV'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214044766897866505)
,p_report_id=>wwv_flow_imp.id(213839531986164374)
,p_name=>'schwerwiegend'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#ffc0c0'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214045249879866506)
,p_report_id=>wwv_flow_imp.id(213839531986164374)
,p_name=>unistr('auff\00E4llig')
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#fff5ce'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214044380020866505)
,p_report_id=>wwv_flow_imp.id(213839531986164374)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS_AUSFUEHREN'
,p_operator=>'='
,p_expr=>'0'
,p_condition_sql=>'"STATUS_AUSFUEHREN" = to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# = #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(213843572030170320)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>unistr('Von Ihnen best\00E4tigte Aktionen')
,p_report_seq=>10
,p_report_alias=>'BESTAETIGTE_AKTIONEN'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:HAUS_LFD_NR:PLZ:ORT:STR:NR:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:PROBLEMKATEGORIE:VALIDIERUNG:STATUS'
,p_sort_column_1=>'PROBLEMKATEGORIE'
,p_sort_direction_1=>'ASC NULLS LAST'
,p_sort_column_2=>'ZEILENNUMMER_CSV'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214046248265870323)
,p_report_id=>wwv_flow_imp.id(213843572030170320)
,p_name=>'schwerwiegend'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" < to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#ffc0c0'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214046563314870324)
,p_report_id=>wwv_flow_imp.id(213843572030170320)
,p_name=>unistr('auff\00E4llig')
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'>'
,p_expr=>'0'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" > to_number(#APXWS_EXPR#)) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# > #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#fff5ce'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214045816619870323)
,p_report_id=>wwv_flow_imp.id(213843572030170320)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'STATUS_AUSFUEHREN'
,p_operator=>'='
,p_expr=>'1'
,p_condition_sql=>'"STATUS_AUSFUEHREN" = to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# = #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(214036486028811570)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'Schwerwiegende Probleme'
,p_report_seq=>10
,p_report_alias=>'491207'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:HAUS_LFD_NR:PLZ:ORT:STR:NR:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:PROBLEMKATEGORIE:VALIDIERUNG:STATUS'
,p_sort_column_1=>'ZEILENNUMMER_CSV'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'0'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'0'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'0'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'0'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'0'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214043806124861194)
,p_report_id=>wwv_flow_imp.id(214036486028811570)
,p_name=>'schwerwiegend'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'is not null'
,p_condition_sql=>' (case when ("SCHWERWIEGEND" is not null) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#ffc0c0'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(214043370511861194)
,p_report_id=>wwv_flow_imp.id(214036486028811570)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'SCHWERWIEGEND'
,p_operator=>'<'
,p_expr=>'0'
,p_condition_sql=>'"SCHWERWIEGEND" < to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# < #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(205941589003897806)
,p_plug_name=>'Monitoring AKTIONSLISTE'
,p_parent_plug_id=>wwv_flow_imp.id(203611900182478413)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SEQ_ID, N001, N002, N003, N005, C001, C002, C003, C005, C006, C007, C008',
'  FROM APEX_COLLECTIONS ',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE '))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Monitoring AKTIONSLISTE'
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
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(205941731874897807)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>41025870784815131
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205941831474897808)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Seq Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205941919351897809)
,p_db_column_name=>'N001'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'N001'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205941963047897810)
,p_db_column_name=>'N002'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'N002'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942062346897811)
,p_db_column_name=>'N003'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'N003'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942224285897812)
,p_db_column_name=>'N005'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'N005'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942337378897813)
,p_db_column_name=>'C001'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'C001'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942429392897814)
,p_db_column_name=>'C002'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'C002'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942474235897815)
,p_db_column_name=>'C003'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'C003'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942602446897816)
,p_db_column_name=>'C005'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'C005'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942693532897817)
,p_db_column_name=>'C006'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'C006'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942799488897818)
,p_db_column_name=>'C007'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'C007'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(205942924005897819)
,p_db_column_name=>'C008'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'C008'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(206060300151616175)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'411445'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ_ID:N001:N002:N003:N005:C001:C002:C003:C005:C006:C007:C008'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203611981922478414)
,p_plug_name=>'Schritt 4 von 5'
,p_parent_plug_id=>wwv_flow_imp.id(203611647480478410)
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_STEP'
,p_plug_display_when_cond2=>'4'
,p_plug_header=>'<div class="datei">Datei: <span class="dateiname">&P11_FILE_NAME.</span></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(206135320976490784)
,p_name=>unistr('Jetzt ausf\00FChren:')
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>10
,p_region_template_options=>'t-Region--noUI:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--variableLabelLarge:t-AVPList--leftAligned:t-Report--hideNoPagination'
,p_grid_column_span=>8
,p_display_column=>3
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT GEPLANTE_AKTION',
'     , ''Anzahl: '' || TO_CHAR(COUNT(*)) AS ANZAHL ',
'FROM (',
'    SELECT N002 AS GEPLANTE_AKTION',
'         , N003 AS STATUS',
'       --, N005 AS PROBLEMKATEGORIE',
'      FROM APEX_COLLECTIONS',
'     WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
'       AND N003 = 1',
'    )',
' GROUP BY GEPLANTE_AKTION'))
,p_display_when_condition=>':P11_SHOWSTOPPER = 0 AND :P11_ANZAHL_AKTIONEN > 0'
,p_display_when_cond2=>'SQL'
,p_display_condition_type=>'EXPRESSION'
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236588546838961968)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(206135379781490785)
,p_query_column_id=>1
,p_column_alias=>'GEPLANTE_AKTION'
,p_column_display_sequence=>10
,p_column_heading=>'Aktion'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_imp.id(205997260652446545)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(206135561501490787)
,p_query_column_id=>2
,p_column_alias=>'ANZAHL'
,p_column_display_sequence=>30
,p_column_heading=>'Anzahl'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(206135776372490789)
,p_name=>'Ausgeschlossen:'
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>20
,p_region_template_options=>'t-Region--noUI:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--variableLabelLarge:t-AVPList--leftAligned:t-Report--hideNoPagination'
,p_grid_column_span=>8
,p_display_column=>3
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT GEPLANTE_AKTION',
'     , ''Anzahl: '' || TO_CHAR(COUNT(*)) AS ANZAHL ',
'FROM (',
'    SELECT N002 AS GEPLANTE_AKTION',
'         , N003 AS STATUS',
'      FROM APEX_COLLECTIONS',
'     WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
'       AND N003 = 0',
'    )',
' GROUP BY GEPLANTE_AKTION'))
,p_display_when_condition=>'P11_ANZAHL_AUSGESCHLOSSENE_AKTIONEN'
,p_display_condition_type=>'ITEM_IS_NOT_ZERO'
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236588546838961968)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(206135920411490790)
,p_query_column_id=>1
,p_column_alias=>'GEPLANTE_AKTION'
,p_column_display_sequence=>10
,p_column_heading=>'Aktion'
,p_disable_sort_column=>'N'
,p_display_as=>'TEXT_FROM_LOV_ESC'
,p_named_lov=>wwv_flow_imp.id(209102160182969952)
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(206135976710490791)
,p_query_column_id=>2
,p_column_alias=>'ANZAHL'
,p_column_display_sequence=>20
,p_column_heading=>'Anzahl'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(206136178821490793)
,p_plug_name=>'Infotext AKTION_1'
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<div class="step-infobox"><p>Im n\00E4chsten Schritt werden alle ausgew\00E4hlten Aktionen tats\00E4chlich durchgef\00FChrt.</p>'),
unistr('<p>Sie k\00F6nnen anschlie\00DFend eine detaillierte Zusammenfassung der ausgef\00FChrten Aktionen herunterladen.</p></div>')))
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P11_ANZAHL_SHOWSTOPPER = 0 AND :P11_ANZAHL_AKTIONEN > 0 AND :P11_ANZAHL_AUSGESCHLOSSENE_AKTIONEN = 0'
,p_plug_display_when_cond2=>'SQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(206138776272490819)
,p_plug_name=>'Infotext AKTION_1 und AKTION_0'
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<div class="step-infobox"><p>Im n\00E4chsten Schritt werden alle ausgew\00E4hlten Aktionen tats\00E4chlich durchgef\00FChrt.</p>'),
unistr('<p>Sie k\00F6nnen anschlie\00DFend eine detaillierte Zusammenfassung der durchgef\00FChrten und ausgeschlossenen Aktionen herunterladen.</p></div>')))
,p_plug_display_condition_type=>'EXPRESSION'
,p_plug_display_when_condition=>':P11_ANZAHL_SHOWSTOPPER = 0 AND :P11_ANZAHL_AKTIONEN > 0 AND :P11_ANZAHL_AUSGESCHLOSSENE_AKTIONEN> 0'
,p_plug_display_when_cond2=>'SQL'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(206138931304490820)
,p_plug_name=>'Infotext AKTION_0'
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>unistr('<p style="margin:3em 0 0 0;text-align:center">Sie haben f\00FCr alle Zeilen der Liste die Verarbeitung ausgeschlossen. Indem Sie zum vorigen Schritt zur\00FCckgehen, k\00F6nnen Sie Ihre Auswahl \00E4ndern.</p>')
,p_plug_display_condition_type=>'ITEM_IS_ZERO'
,p_plug_display_when_condition=>'P11_ANZAHL_AKTIONEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(211587374783690594)
,p_plug_name=>'Infotext SHOWSTOPPER'
,p_parent_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('<div class="step-infobox"><p>Der Import kann nicht durchgef\00FChrt werden.</p>'),
unistr('<p>Im vorausgehenden Schritt wurden schwerwiegende Probleme bei der Pr\00FCfung der Daten ermittelt. Um die Liste importieren zu k\00F6nnen, schlie\00DFen Sie bitte s\00E4mtliche schwerwiegenden Problemf\00E4lle von der Ausf\00FChrung aus.</p></div>')))
,p_plug_display_condition_type=>'ITEM_IS_NOT_ZERO'
,p_plug_display_when_condition=>'P11_ANZAHL_SHOWSTOPPER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203612090053478415)
,p_plug_name=>'Schritt 5 von 5: Zusammenfassung'
,p_parent_plug_id=>wwv_flow_imp.id(203611647480478410)
,p_region_template_options=>'#DEFAULT#:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_STEP'
,p_plug_display_when_cond2=>'5'
,p_plug_header=>'<div class="datei">Datei: <span class="dateiname">&P11_FILE_NAME.</span></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(206136458250490795)
,p_plug_name=>'IR_AUSGEFUEHRTE_AKTIONEN'
,p_parent_plug_id=>wwv_flow_imp.id(203612090053478415)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SEQ_ID,',
'       N001 AS ZEILENNUMMER_CSV,',
'       CASE WHEN N004 = 0 THEN TO_NUMBER(NULL) ELSE N002 END AS GEPLANTE_AKTION,',
'       N003 AS STATUS,',
'       N004 AS FEHLERCODE,',
'       N005 AS PROBLEMKATEGORIE,',
'       C001 AS HAUS_LFD_NR,',
'       C002 AS VMC_ALT,',
'       C003 AS VMC_NEU,',
'       CASE WHEN :P11_ANZAHL_FEHLER = 0 AND C004 IS NULL THEN ''erfolgreich'' ELSE C004 END AS FEHLERMELDUNG,',
'       C005 AS VALIDIERUNG,',
'       NVL(C006, ''-'') AS ADRESSE,',
'       NVL(C007, ''-'') AS VMC_ALT_BEZEICHNUNG,',
'       CASE WHEN N003 = 1 THEN NVL(C008, ''-'') END AS VMC_NEU_BEZEICHNUNG,',
'       C011 AS STR,',
'       C012 AS NR,',
'       C013 AS ZUS,',
'       C014 AS PLZ,',
'       C015 AS ORT,',
'       CASE WHEN :P11_ANZAHL_FEHLER > 0 OR N004 IS NOT NULL THEN 0 ELSE 1 END AS AKTION_AUSGEFUEHRT',
'  FROM APEX_COLLECTIONS C',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P11_ANZAHL_FEHLER'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'IR_AUSGEFUEHRTE_AKTIONEN'
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
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(206136487023490796)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>41220625933408120
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206136599216490797)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Seq Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_display_condition_type=>'NEVER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206136726218490798)
,p_db_column_name=>'ZEILENNUMMER_CSV'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Zeile'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206136762306490799)
,p_db_column_name=>'GEPLANTE_AKTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Geplante Aktion'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_imp.id(206007217016494724)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206136873356490800)
,p_db_column_name=>'PROBLEMKATEGORIE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Problemkategorie'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206136973487490801)
,p_db_column_name=>'HAUS_LFD_NR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'HAUS_LFD_NR'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137119657490802)
,p_db_column_name=>'VMC_ALT'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Vmc Alt'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137173971490803)
,p_db_column_name=>'VMC_NEU'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Vmc Neu'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137328830490804)
,p_db_column_name=>'VALIDIERUNG'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Validierung'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137541587490806)
,p_db_column_name=>'ADRESSE'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Adresse'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137633640490807)
,p_db_column_name=>'VMC_ALT_BEZEICHNUNG'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Vermarktungscluster bisher'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137724082490808)
,p_db_column_name=>'VMC_NEU_BEZEICHNUNG'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Vorgesehener neuer Vermarktungscluster'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137855941490809)
,p_db_column_name=>'STR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Str'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137890028490810)
,p_db_column_name=>'NR'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Nr'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206137993875490811)
,p_db_column_name=>'ZUS'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Zus'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206138116072490812)
,p_db_column_name=>'PLZ'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Plz'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206138165732490813)
,p_db_column_name=>'ORT'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Ort'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(206138302315490814)
,p_db_column_name=>'STATUS'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Status'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(209051054398315183)
,p_db_column_name=>'FEHLERCODE'
,p_display_order=>190
,p_column_identifier=>'U'
,p_column_label=>'Fehlercode'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(209050786760315181)
,p_db_column_name=>'FEHLERMELDUNG'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Abschlussmeldung'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(209051192549315185)
,p_db_column_name=>'AKTION_AUSGEFUEHRT'
,p_display_order=>210
,p_column_identifier=>'V'
,p_column_label=>unistr('ausgef\00FChrt')
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_column_alignment=>'CENTER'
,p_rpt_named_lov=>wwv_flow_imp.id(199656101876737763)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(208698150026259062)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'437823'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ZEILENNUMMER_CSV:HAUS_LFD_NR:ADRESSE:VMC_ALT_BEZEICHNUNG:GEPLANTE_AKTION:VMC_NEU_BEZEICHNUNG:FEHLERCODE:FEHLERMELDUNG:'
,p_sort_column_1=>'ZEILENNUMMER_CSV'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(206139158870490822)
,p_plug_name=>'Hinweis auf Fehler'
,p_parent_plug_id=>wwv_flow_imp.id(203612090053478415)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>unistr('<div style="margin:3em;background-color:#FF9;padding:1em"><span class="fa fa-exclamation-triangle" style="padding-right:2em"></span><b>Bei der Ausf\00FChrung des Imports sind technische Fehler aufgetreten. Aus diesem Grund wurden alle Aktionen zur\00FCckgeno')
||'mmen.</b></div>'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_plug_display_when_condition=>'P11_ANZAHL_FEHLER'
,p_plug_display_when_cond2=>'0'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(209051113075315184)
,p_plug_name=>unistr('Hinweis alle Aktionen ausgef\00FChrt')
,p_parent_plug_id=>wwv_flow_imp.id(203612090053478415)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>unistr('<div style="margin:3em"><span class="fa fa-flag-checkered" style="padding-right:2em"></span>Alle ausgew\00E4hlten Aktionen wurden erfolgreich ausgef\00FChrt.</div>')
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P11_ANZAHL_FEHLER'
,p_plug_display_when_cond2=>'0'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203781762856764141)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236566426862961958)
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(236499478762961929)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>wwv_flow_imp.id(236623521283961985)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(204015750543143261)
,p_plug_name=>'Wizard "Listenimport"'
,p_region_template_options=>'#DEFAULT#:margin-top-lg'
,p_component_template_options=>'#DEFAULT#:t-WizardSteps--displayLabels'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_list_id=>wwv_flow_imp.id(204014745118143260)
,p_plug_source_type=>'NATIVE_LIST'
,p_list_template_id=>wwv_flow_imp.id(236614323281961981)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(205278966454794977)
,p_plug_name=>'Monitoring'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(176543914940240884)
,p_plug_name=>'AKTIONSLISTE'
,p_parent_plug_id=>wwv_flow_imp.id(205278966454794977)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'            SELECT seq_id,',
'                   n001 AS zeilennummer_csv,',
'                   n002 AS geplante_aktion,',
'                   n003 AS status,',
'                   n004 AS fehlercode,',
'                   n005 AS problemkategorie,',
'                   c001 AS haus_lfd_nummer,',
'                   c002 AS vmc_alt,',
'                   c003 AS vmc_neu,',
'                   C004 AS ERROR_MESSAGE,',
'                   c005 AS validierung,',
unistr('                   --- nur wichtig f\00FCr das anschlie\00DFende UPDATE_MEMBER:'),
'                   c006, c007, c008, c009, c010, c011, c012, c013, c014, c015',
'              FROM apex_collections',
'             WHERE collection_name = ''AKTIONSLISTE'''))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'AKTIONSLISTE'
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
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(176544048699240885)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>11628187609158209
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544077199240886)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'SEQ'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544230969240887)
,p_db_column_name=>'ZEILENNUMMER_CSV'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'N001 CSV#'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544339280240888)
,p_db_column_name=>'GEPLANTE_AKTION'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'N002 Geplante Aktion'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544401701240889)
,p_db_column_name=>'STATUS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'N003 Status'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544493996240890)
,p_db_column_name=>'PROBLEMKATEGORIE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'N005 Problemkategorie'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544591812240891)
,p_db_column_name=>'HAUS_LFD_NUMMER'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'C001 HAUS_LFD_NR'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544712700240892)
,p_db_column_name=>'VMC_ALT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'C002 VMC_ALT'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544820306240893)
,p_db_column_name=>'VMC_NEU'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'C003 VMC_NEU'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544878688240894)
,p_db_column_name=>'VALIDIERUNG'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'C005 Validierung'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176544997944240895)
,p_db_column_name=>'C006'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'C006'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545097939240896)
,p_db_column_name=>'C007'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'C007'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545231454240897)
,p_db_column_name=>'C008'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'C008'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545305206240898)
,p_db_column_name=>'C009'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'C009'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545378388240899)
,p_db_column_name=>'C010'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'C010'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545464049240900)
,p_db_column_name=>'C011'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'C011'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545562825240901)
,p_db_column_name=>'C012'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'C012'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545730237240902)
,p_db_column_name=>'C013'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'C013'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545847099240903)
,p_db_column_name=>'C014'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'C014'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545881844240904)
,p_db_column_name=>'C015'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'C015'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176545973047240905)
,p_db_column_name=>'FEHLERCODE'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'N004 Fehlercode'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(176546130350240906)
,p_db_column_name=>'ERROR_MESSAGE'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'C004 Error Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(176861282314564092)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'119455'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ_ID:ZEILENNUMMER_CSV:GEPLANTE_AKTION:STATUS:FEHLERCODE:PROBLEMKATEGORIE:HAUS_LFD_NUMMER:VMC_ALT:VMC_NEU:ERROR_MESSAGE:VALIDIERUNG:C006:C007:C008:C009:C010:C011:C012:C013:C014:C015:'
,p_sort_column_1=>'ZEILENNUMMER_CSV'
,p_sort_direction_1=>'ASC'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(205279104021794978)
,p_name=>'APEX_APPLICATION_TEMP_FILES'
,p_parent_plug_id=>wwv_flow_imp.id(205278966454794977)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'TABLE'
,p_query_table=>'APEX_APPLICATION_TEMP_FILES'
,p_include_rowid_column=>false
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236583898978961966)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279194673794979)
,p_query_column_id=>1
,p_column_alias=>'ID'
,p_column_display_sequence=>10
,p_column_heading=>'Id'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279267530794980)
,p_query_column_id=>2
,p_column_alias=>'APPLICATION_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Application Id'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279362725794981)
,p_query_column_id=>3
,p_column_alias=>'NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Name'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279476376794982)
,p_query_column_id=>4
,p_column_alias=>'FILENAME'
,p_column_display_sequence=>40
,p_column_heading=>'Filename'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279630982794983)
,p_query_column_id=>5
,p_column_alias=>'MIME_TYPE'
,p_column_display_sequence=>50
,p_column_heading=>'Mime Type'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(205279725257794984)
,p_query_column_id=>6
,p_column_alias=>'CREATED_ON'
,p_column_display_sequence=>60
,p_column_heading=>'Created On'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205280576179794993)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(203611819011478412)
,p_button_name=>'BTN_ZURUECK_2'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>unistr('zur\00FCck')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-left'
,p_button_comment=>unistr('Geht zur Startseite 1 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205281059815794997)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(203611900182478413)
,p_button_name=>'BTN_ZURUECK_3'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>unistr('zur\00FCck')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-left'
,p_button_comment=>unistr('Geht zur vorigen Seite 2 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205281244819794999)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_button_name=>'BTN_ZURUECK_4'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>unistr('zur\00FCck')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-left'
,p_button_comment=>unistr('Geht zur vorigen Seite 3 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211586801814690588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(203611746355478411)
,p_button_name=>'BTN_CANCEL_1'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Import abbrechen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:11::'
,p_icon_css_classes=>'fa-ban'
,p_button_comment=>unistr('Geht zur vorigen Seite 3 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205279940182794986)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(203611746355478411)
,p_button_name=>'BTN_WEITER_1'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('weiter zum n\00E4chsten Schritt ...')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_button_comment=>unistr('\00D6ffnet die Folgeseite 2 im Wizard')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211586267126690583)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_button_name=>'BTN_CANCEL_4'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Import abbrechen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:11::'
,p_icon_css_classes=>'fa-ban'
,p_button_comment=>unistr('Geht zur vorigen Seite 3 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211586626894690586)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(203611900182478413)
,p_button_name=>'BTN_CANCEL_3'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Import abbrechen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:11::'
,p_icon_css_classes=>'fa-ban'
,p_button_comment=>unistr('Geht zur vorigen Seite 3 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211586722590690587)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(203611819011478412)
,p_button_name=>'BTN_CANCEL_2'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Import abbrechen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:11::'
,p_icon_css_classes=>'fa-ban'
,p_button_comment=>unistr('Geht zur vorigen Seite 3 im Wizard zur\00FCck')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205280812294794995)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(203611819011478412)
,p_button_name=>'BTN_WEITER_2'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('weiter zum n\00E4chsten Schritt ...')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_button_comment=>unistr('\00D6ffnet die Folgeseite 3 im Wizard')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205281154418794998)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(203611900182478413)
,p_button_name=>'BTN_WEITER_3'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('weiter zum n\00E4chsten Schritt ...')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_button_comment=>unistr('\00D6ffnet die Folgeseite 4 im Wizard')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(205281286064795000)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_button_name=>'BTN_WEITER_4'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--gapLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('Weiter: Gew\00E4hlte Aktionen jetzt ausf\00FChren und Zusammenfassung anzeigen')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_condition=>':P11_ANZAHL_SHOWSTOPPER = 0 AND :P11_ANZAHL_AKTIONEN > 0'
,p_button_condition2=>'SQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-chevron-circle-right'
,p_button_comment=>unistr('\00D6ffnet die Folgeseite 5 im Wizard (Button erscheint nicht, wenn die Vorpr\00FCfung Showstopper entdeckt hat)')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(206134895230490780)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(205564942864360016)
,p_button_name=>'BTN_AUFFAELLIGE_DEAKTIVIEREN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('S\00E4mtliche auff\00E4lligen Zeilen von der Verarbeitung ausschlie\00DFen')
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_alignment=>'RIGHT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NULL',
'  FROM APEX_COLLECTIONS',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
'   AND N005 > 0'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-ban'
,p_button_cattributes=>unistr('title="Durch Klicken stellen Sie die Spalte ''Aktion ausf\00FChren'' f\00FCr alle Zeilen, die eine Auff\00E4lligkeit zeigen,  auf ''nein''."')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211587552265690595)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(205564942864360016)
,p_button_name=>'BTN_SHOWSTOPPER_DEAKTIVIEREN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Zeilen mit schwerwiegenden Problemen (rot markiert) von der Verarbeitung ausschlie\00DFen')
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_alignment=>'RIGHT'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NULL',
'  FROM APEX_COLLECTIONS',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
'   AND N005 < 0'))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-ban'
,p_button_cattributes=>unistr('title="Durch Klicken stellen Sie die Spalte ''Aktion ausf\00FChren'' f\00FCr alle Zeilen, die ein schwerwiegendes Problem zeigen,  auf ''nein''."')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205280426604794991)
,p_branch_name=>'BTN_WEITER_1'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-2:&DEBUG.::P11_STEP:2&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205279940182794986)
,p_branch_sequence=>11
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205280666034794994)
,p_branch_name=>'BTN_ZURUECK_2'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-1:&DEBUG.::P11_STEP:1&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205280576179794993)
,p_branch_sequence=>31
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205280891540794996)
,p_branch_name=>'BTN_WEITER_2'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-3:&DEBUG.:RR,IR_GEPLANTE_AKTIONEN:P11_STEP:3&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205280812294794995)
,p_branch_sequence=>51
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205281527789795002)
,p_branch_name=>'BTN_ZURUECK_3'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-2:&DEBUG.::P11_STEP:2&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205281059815794997)
,p_branch_sequence=>61
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205281598784795003)
,p_branch_name=>'BTN_WEITER_3'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-4:&DEBUG.::P11_STEP:4&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205281154418794998)
,p_branch_sequence=>81
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205281673310795004)
,p_branch_name=>'BTN_ZURUECK_4'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-3:&DEBUG.::P11_STEP:3&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205281244819794999)
,p_branch_sequence=>101
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(205281826655795005)
,p_branch_name=>'BTN_WEITER_4'
,p_branch_action=>'f?p=&APP_ID.:11:&SESSION.:STEP-5:&DEBUG.::P11_STEP:5&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(205281286064795000)
,p_branch_sequence=>121
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203612199800478416)
,p_name=>'P11_FILE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(203611746355478411)
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_colspan=>5
,p_grid_column=>4
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'display_as', 'DROPZONE_BLOCK',
  'dropzone_description', unistr('W\00E4hlen Sie eine einzelne .csv- oder .xlsx-Datei aus oder ziehen Sie die Datei in dieses Feld.'),
  'dropzone_title', 'Objektliste hochladen',
  'file_types', '.csv,text/csv,.xlsx, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'purge_file_at', 'SESSION',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
,p_item_comment=>'Die Dropzone akzeptiert nur CSV und XLS-Uploads. Sollte einer dieser beiden Dateitypen unberechtigterweise abgelehnt werden, dann bitte den Eintrag unter "File Types" (.csv,text/csv,.xlsx, application/vnd.openxmlformats-officedocument.spreadsheetml.s'
||unistr('heet) komplett entfernen, denn dieses Feature scheint in APEX 21.2 noch nicht ganz zuverl\00E4ssig zu funktionieren.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203612298398478417)
,p_name=>'P11_STEP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205280197756794989)
,p_name=>'P11_FILE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Speichert die ID der zuletzt hochgeladenen Datei aus APEX_APPLICATION_TEMP_FILES (ohne den Namensbestandteil)'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205281998787795007)
,p_name=>'P11_SPALTENAUSWAHL'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(205282753481795014)
,p_prompt=>unistr('Wie lautet die Spalten\00FCberschrift f\00FCr die<br/>Objekte (typischerweise HAUS_LFD_NR)?')
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT D, R FROM TABLE( pck_vermarktungscluster.get_header_columns (',
'        pib_blob_content   => PCK_VERMARKTUNGSCLUSTER.f_blob_content_temp_files(:P11_FILE_ID),',
'        piv_dateiname      => :P11_FILE_NAME,',
'        pin_zeilennummer   => NVL(:P11_ZEILENAUSWAHL, 1)',
'    ))'))
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205282104278795008)
,p_name=>'P11_FILE_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Speichert den Namen der zuletzt hochgeladenen Datei aus APEX_APPLICATION_TEMP_FILES (ohne den ID-bestandteil)'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205282307803795010)
,p_name=>'P11_AKTION'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(205282803715795015)
,p_prompt=>unistr('Welche Aktion soll ausgef\00FChrt werden?')
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LISTENIMPORT_AKTION_1'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''Objekte einem Vermarktungscluster hinzuf\00FCgen'' AS D, 0 AS R FROM DUAL UNION ALL'),
'SELECT ''Objekte aus ihren Vermarktungsclustern entfernen'' AS D, -1 AS R FROM DUAL UNION ALL',
'SELECT ''Objekte in anderen Vermarktungscluster verschieben'' AS D, 1 AS R FROM DUAL'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('- bitte ausw\00E4hlen -')
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205282632915795013)
,p_name=>'P11_CLUSTERAUSWAHL'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(205282803715795015)
,p_prompt=>unistr('Zuk\00FCnftiger Vermarktungscluster:')
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'VERMARKTUNGSCLUSTER'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT BEZEICHNUNG AS D, VC_LFD_NR AS R',
'  FROM VERMARKTUNGSCLUSTER',
' ORDER BY BEZEICHNUNG'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('- bitte ausw\00E4hlen -')
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205283801489795025)
,p_name=>'P11_HEADER_SPALTENNAME'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert die \00DCberschrift, die der CSV-Scan bei der SUche nach HAUS_LFD_NR ermittelt hat.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205283899089795026)
,p_name=>'P11_HEADER_ZEILENNUMMER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Speichert die Zeilennummer, in welcher der CSV-Scan die HAUS_LFD_NR ermittelt hat.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205522104721143277)
,p_name=>'P11_HEADER_SPALTENNUMMER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(204015750543143261)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Speichert die Spaltennummer, in welcher der CSV-Scan die HAUS_LFD_NR ermittelt hat. Mit dieser wird das Item P11_SPALTENAUSWAHL vorbelegt.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(205564417881360011)
,p_name=>'P11_ZEILENAUSWAHL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(205282753481795014)
,p_prompt=>unistr('Wo befindet sich die Spalten\00FCberschrift?')
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Erste Zeile;1,Zweite Zeile;2,Dritte Zeile;3'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- automatisch ermitteln -'
,p_cHeight=>1
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(206138505542490816)
,p_name=>'P11_ANZAHL_AKTIONEN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert, wie viele Aktionen aus der Importliste letztendlich ausgef\00FChrt werden sollen. Dient dazu, bei mehreren Objekten zu bestimmen, ob sie angezeigt werden')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(206138714948490818)
,p_name=>'P11_ANZAHL_AUSGESCHLOSSENE_AKTIONEN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert, wie viele Aktionen aus der Importliste nicht ausgef\00FChrt werden sollen. Dient dazu, bei mehreren Objekten zu bestimmen, ob sie angezeigt werden')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(209050894229315182)
,p_name=>'P11_ANZAHL_FEHLER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(206139158870490822)
,p_prompt=>'Anzahl aufgetretener Fehler:'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211587252263690592)
,p_name=>'P11_ANZAHL_SHOWSTOPPER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(203611981922478414)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert, wie viele nicht ausgeschlossene Aktionen existieren, obwohl die Vorpr\00FCfung SCHWERIEGENDE Probleme festgestellt hat, weswegen ein Import nicht erfolgreich sein kann. Wenn dieser Wert > 0 ist, wird dem Benutzer der letzte Schritt verweigert.')
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(203612366496478418)
,p_computation_sequence=>10
,p_computation_item=>'P11_STEP'
,p_computation_point=>'AFTER_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'1'
,p_computation_comment=>unistr('Es muss in jedem Fall zu Schritt 1 gesprungen werden, wenn keine FILE_ID gew\00E4hlt ist.')
,p_compute_when=>'P11_FILE_ID'
,p_compute_when_type=>'ITEM_IS_NULL'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(205280539714794992)
,p_validation_name=>'Step-1: Genau eine Datei'
,p_validation_sequence=>10
,p_validation=>':P11_FILE IS NOT NULL AND INSTR(:P11_FILE, '':'') = 0'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Bitte w\00E4hlen Sie genau eine Datei aus.')
,p_when_button_pressed=>wwv_flow_imp.id(205279940182794986)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(205282180768795009)
,p_validation_name=>unistr('Step-2: Spalte ausgew\00E4hlt')
,p_validation_sequence=>20
,p_validation=>':P11_SPALTENAUSWAHL IS NOT NULL'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Bitte treffen Sie eine Auswahl f\00FCr die Spalten\00FCberschrift')
,p_when_button_pressed=>wwv_flow_imp.id(205280812294794995)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(205282452186795011)
,p_validation_name=>unistr('Step-2: Aktion ausgew\00E4hlt')
,p_validation_sequence=>30
,p_validation=>':P11_AKTION IS NOT NULL'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Bitte w\00E4hlen Sie die auszuf\00FChrende Aktion')
,p_when_button_pressed=>wwv_flow_imp.id(205280812294794995)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(205943099065897821)
,p_validation_name=>unistr('Step-2: Vermarktungscluster ausgew\00E4hlt')
,p_validation_sequence=>40
,p_validation=>':P11_CLUSTERAUSWAHL IS NOT NULL'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Bitte geben Sie einen Vermarktungscluster an'
,p_validation_condition=>'P11_AKTION'
,p_validation_condition2=>'0:1'
,p_validation_condition_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_when_button_pressed=>wwv_flow_imp.id(205280812294794995)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(205282884612795016)
,p_name=>'P11_AKTION'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_AKTION'
,p_condition_element=>'P11_AKTION'
,p_triggering_condition_type=>'GREATER_THAN_OR_EQUAL'
,p_triggering_expression=>'0'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>'Je nach Auswahl der Aktion wird die Selectliste mit der Auswahl des Vermakrtungsclusters ein- oder ausgeblendet. Lautet die Aktion "Entfernen", so soll keine VMC-Auswahl sichtbar sein.'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(205282976954795017)
,p_event_id=>wwv_flow_imp.id(205282884612795016)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SHOW'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CLUSTERAUSWAHL'
,p_da_action_comment=>'Zeige die untere Selectliste mit den Bezeichnungen der Vermarktungscluster'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(205283093433795018)
,p_event_id=>wwv_flow_imp.id(205282884612795016)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CLUSTERAUSWAHL'
,p_da_action_comment=>'Verberge die untere Selectliste mit den Bezeichnungen der Vermarktungscluster'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(209050366174315177)
,p_name=>'P11_AKTION_2'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_AKTION'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('Hier wird der Fall behandelt, dass der Benutzer zun\00E4chst die untere Selectliste sieht, dann oben jedoch wieder auf "bitte ausw\00E4hlen" umschaltet: Dann soll in jedem Fall die Selectliste mit den VMC-Bezeichnungen ausgeblendet werden.')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(209050715091315180)
,p_event_id=>wwv_flow_imp.id(209050366174315177)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CLUSTERAUSWAHL'
,p_client_condition_type=>'NULL'
,p_client_condition_element=>'P11_AKTION'
,p_da_action_comment=>unistr('Wenn nach der Asuwahl die obere Selectliste auf "bitte ausw\00E4hlen" steht, wird die untere ausgeblendet.')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(205564562804360013)
,p_name=>'P11_ZEILENAUSWAHL'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P11_ZEILENAUSWAHL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(205564692043360014)
,p_event_id=>wwv_flow_imp.id(205564562804360013)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'P11_ZEILENAUSWAHL'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(205941019458897800)
,p_name=>'IR: AKTION_UMSCHALTEN'
,p_event_sequence=>40
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'input[name^="seq-"]'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#IR_GEPLANTE_AKTIONEN'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('Reaktion auf das Umschalten des Switches "Ausf\00FChren?": Per AJAX den Datensatz in der Collection aktualisieren und im Callback die Farbe der Zeile entsprechend \00E4ndern')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(205941088568897801)
,p_event_id=>wwv_flow_imp.id(205941019458897800)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let $schalter = $(this.triggeringElement);',
'let schalterstellung = $schalter.attr(''value''); // e.g. 1',
'let schalterId = $schalter.attr(''id''); // e.g. seq-308_Y, der Underscore gefolgt von Y|N kommt aus APEX',
'let underscore = schalterId.indexOf("_");',
'let seqId = schalterId.substr(4, underscore -4); // e.g. 308',
'',
'apex.server.process ("ASP_AKTION_UMSCHALTEN", ',
'	{x01 : seqId,',
'	 x02 : schalterstellung',
'	},',
'    {type    : ''GET'', dataType: ''text'',',
'     success : function(text) {',
'	             apex.message.showPageSuccess(text);',
'               }',
'	}',
');'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(206139402842490825)
,p_name=>unistr('Auswahl VMC zun\00E4chst ausblenden')
,p_event_sequence=>50
,p_condition_element=>'P11_AKTION'
,p_triggering_condition_type=>'NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_da_event_comment=>unistr('Erst sobald der Benutzer eine Auswahl der Aktion get\00E4tigt hat, entscheidet sich, ob die Selectliste darunter mit den Vermarktungsclustern angezeigt wird. Bis dahin soll nur die Aktions-Dropdowliste selbst sichtbar sein. Falls der Benutzer von Step 3 ')
||unistr('"zur\00FCck" kommt, aht P11_AKTION bereits einen Wert; dann darf diese Aktion nicht z\00FCnden.')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(206139470621490826)
,p_event_id=>wwv_flow_imp.id(206139402842490825)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_HIDE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P11_CLUSTERAUSWAHL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(205283740307795024)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>unistr('Step-2: Spalte HAUS_LFD_NR vorausw\00E4hlen')
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P11_FILE_ID IS NOT NULL THEN',
'    PCK_VERMARKTUNGSCLUSTER.p_finde_spalte_in_csv_header (',
'        pib_blob_content      => PCK_VERMARKTUNGSCLUSTER.f_blob_content_temp_files(:P11_FILE_ID),',
'        piv_dateiname         => :P11_FILE_NAME,',
'        piv_suchmuster        => ''%HAUS%LFD%NR%'',',
'        pin_zeilennummer      => :P11_ZEILENAUSWAHL,',
'        pin_scan_zeilen       => 3,',
'        pon_zeilennummer      => :P11_HEADER_ZEILENNUMMER,',
'        pon_spaltennummer     => :P11_HEADER_SPALTENNUMMER,',
'        pov_spaltenname       => :P11_HEADER_SPALTENNAME',
'    );',
'    :P11_SPALTENAUSWAHL := :P11_HEADER_SPALTENNUMMER;',
'    IF :P11_HEADER_ZEILENNUMMER IS NOT NULL THEN',
'        :P11_ZEILENAUSWAHL  := :P11_HEADER_ZEILENNUMMER;',
'    END IF;',
'    :P11_ANZAHL_AKTIONEN := NULL;',
'END IF;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P11_STEP'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'2'
,p_internal_uid=>40367879217712348
,p_process_comment=>unistr('Anhand des Inhalts der Importliste wird versucht, die Zeilen- und Spaltennummer der HAUS_LFD_NR zun\00E4chst automatisch zu bestimmen')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(206138645152490817)
,p_process_sequence=>30
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Step-4: Anzahl Aktionen bestimmen'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT NVL(SUM(AKTION_1), 0), NVL(SUM(AKTION_0), 0) ',
'  INTO :P11_ANZAHL_AKTIONEN, :P11_ANZAHL_AUSGESCHLOSSENE_AKTIONEN',
'  FROM (',
'SELECT CASE WHEN AKTION = 1 THEN ANZAHL END AS AKTION_1 ',
'     , CASE WHEN AKTION = 0 THEN ANZAHL END AS AKTION_0',
'  FROM (',
'SELECT N003 AS AKTION, COUNT(*) AS ANZAHL',
'  FROM APEX_COLLECTIONS',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
' GROUP BY N003',
'));',
'',
'SELECT COUNT(*)',
'  INTO :P11_ANZAHL_SHOWSTOPPER',
'  FROM APEX_COLLECTIONS',
' WHERE COLLECTION_NAME = PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE  ',
'   AND N005 < 0 -- schwerwiegendes Problem',
unistr('   AND N003 = 1 -- User m\00F6chte trotzdem ausf\00FChren'),
'   ;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P11_STEP'
,p_process_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_process_when2=>'4'
,p_internal_uid=>41222784062408141
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(205280350162794990)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_WEITER_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_ZEILENAUSWAHL := NULL;',
':P11_SPALTENAUSWAHL := NULL;',
':P11_AKTION := NULL;',
':P11_CLUSTERAUSWAHL := NULL;',
':P11_FILE_NAME := SUBSTR(:P11_FILE, 1 + INSTR(:P11_FILE, ''/''));',
':P11_FILE_ID := SUBSTR(:P11_FILE, 1, INSTR(:P11_FILE, ''/'') -1);',
'DELETE APEX_APPLICATION_TEMP_FILES WHERE ID <> :P11_FILE_ID;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(205279940182794986)
,p_internal_uid=>40364489072712314
,p_process_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('P11_FILE ist eine Kombination aus ID und Dateiname, getrennt durch einen Schr\00E4gstrich (Beispiel: 123456789/dummy.txt).'),
unistr('In diesem Prozess wird der ID-Part in das Page Item :P11_FILE_ID kopiert und alle hochgeladenen Dateien, die nicht diese ID besitzen, gel\00F6scht.')))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209051296768315186)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_WEITER_2'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_region_id apex_application_page_regions.region_id%TYPE;',
'BEGIN',
'    SELECT MAX(region_id)',
'      INTO v_region_id',
'      FROM apex_application_page_regions',
'     WHERE application_id = :app_id',
'       AND page_id     = :app_page_id',
'       AND region_name = ''IR_GEPLANTE_AKTIONEN'';',
unistr('    -- Sicherheitshalber pr\00FCfen, ob der Report mit diesem Alias \00FCberhaupt noch existiert:'),
'    IF v_region_id IS NOT NULL THEN',
'        apex_ir.reset_report(p_page_id => :app_page_id, p_region_id => v_region_id, p_report_alias => ''HAUPTBERICHT'');',
'    END IF;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(205280812294794995)
,p_internal_uid=>44135435678232510
,p_process_comment=>unistr('Sorgt daf\00FCr, dass im STEP-3 der Hauptbereicht (Alias = HAUPTBERICHT) angezeigt wird, auch wenn der Benutzer zuvor einen anderen Report aufgerufen hatte. Bitte beachten: Beim Zur\00FCckkehren von STEP-4 nach STEP-3 erfolgt diese Report-Auswahl nicht.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(206135058167490781)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_AUFFAELLIGE_DEAKTIVIEREN'
,p_process_sql_clob=>'PCK_VERMARKTUNGSCLUSTER.p_alle_auffaelligen_deaktivieren;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(206134895230490780)
,p_internal_uid=>41219197077408105
,p_process_comment=>unistr('Stellt alle Zeilen der Aktionsliste, bei denen ein Problem festgestellt wurde, auf "ausf\00FChren = nein" um')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(211587595488690596)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_SHOWSTOPPER_DEAKTIVIEREN'
,p_process_sql_clob=>'PCK_VERMARKTUNGSCLUSTER.p_showstopper_deaktivieren;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(211587552265690595)
,p_internal_uid=>46671734398607920
,p_process_comment=>unistr('Stellt alle Zeilen der Aktionsliste, bei denen ein Problem festgestellt wurde, auf "ausf\00FChren = nein" um')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(206136296854490794)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_WEITER_4'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P11_ANZAHL_FEHLER := PCK_VERMARKTUNGSCLUSTER.p_listenaktionen_ausfuehren(',
'    piv_aktion => PCK_VERMARKTUNGSCLUSTER.COLLECTION_NAME_AKTIONSLISTE',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(205281286064795000)
,p_internal_uid=>41220435764408118
,p_process_comment=>unistr('F\00FChrt die geplanten Aktionen mit der Importliste jetzt aus. Es gilt das "Alles oder Nichts"-Prinzip: S\00E4mtliche Aktionen werden zur\00FCckgerollt, wenn eine einzige fehlschl\00E4gt.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(206134807639490779)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ASP_AKTION_UMSCHALTEN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_aktion_umschalten(',
'  pin_seq_id           => apex_application.g_x01',
' ,pin_schalterstellung => apex_application.g_x02',
');',
'-- Erfolgsmeldung rechts oben:',
'---htp.p(''g_x01='' || apex_application.g_x01 || '', G-x02='' || apex_application.g_x02);',
unistr('htp.p(CASE apex_application.g_x02 WHEN 1 THEN ''Ausf\00FChrung best\00E4tigt'' WHEN 0 THEN ''Ausf\00FChrung ausgeschlossen'' END);'),
'',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>41218946549408103
,p_process_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'x01: SEQ_ID der Zeile in der Collection, deren Switch umgestellt wurde (NICHT die CSV-Zeilennummer!)',
'x02: Neuer Wert des Switches (0=nein|1=ja)'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(205565056597360017)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Step-3: Aktionsliste erzeugen'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_create_aktionsliste(',
'    pib_blob_content       => PCK_VERMARKTUNGSCLUSTER.f_blob_content_temp_files(:P11_FILE_ID)',
'   ,piv_dateiname          => :P11_FILE_NAME',
'   ,pin_start_zeilennummer => :P11_ZEILENAUSWAHL + 1',
'   ,pin_spaltennummer_haus => :P11_SPALTENAUSWAHL',
'   ,pin_aktion             => :P11_AKTION',
'   ,piv_vmc_neu            => :P11_CLUSTERAUSWAHL ',
'',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(205280812294794995)
,p_internal_uid=>40649195507277341
,p_process_comment=>unistr('Die Importliste wird erneut geparst und mit den Daten aus STEP-2 angereichert. Daraus entsteht in Step 3 die APEX_COLLECTION namens AKTIONSLISTE. Der Benutzer kann die Aktionsliste zeilenweise editieren, bevor sie an STEP-4 zur Ausf\00FChrung weitergegeb')
||'en wird.'
);
wwv_flow_imp.component_end;
end;
/
