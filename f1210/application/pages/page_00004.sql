prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>unistr('Objekte hinzuf\00FCgen')
,p_alias=>'OBJEKTE-HINZUFUEGEN'
,p_step_title=>unistr('Objekte hinzuf\00FCgen')
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var spinner = apex.util.showSpinner();',
'',
'function displayNumChecked(stringFromApplicationProcess) {',
'  let numChecked = stringFromApplicationProcess.replace(/(\r\n|\n|\r)/gm, '''').trim();',
'  $(''#num_checked'').text('''' + numChecked + (numChecked == 1 ? '' eindeutige laufende Nummer'' : '' eindeutige laufende Nummern''));',
'}'))
,p_javascript_code_onload=>'spinner.remove();'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'input.checkbox--ir, #header_checkbox {',
'    cursor:pointer;',
'}',
'',
'.a-GV-frozen--startLast {',
'    border-right-width: var(--a-gv-frozen-last-border-width,2px);',
'    border-width: thin;',
'}',
'.filterItem.selected {background-color:#dee1e4;font-weight:bold}'))
,p_page_template_options=>'#DEFAULT#'
,p_page_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Ersetzt die bisherige Seite 7, @ticket FTTH-561.',
unistr('Durch Einschalten der Build Option "Monitoring" werden viele zus\00E4tzliche Hilfsregionen f\00FCr den Entwickler eingeblendet.'),
unistr('Durch Einschalten der Build Option "Entwicklerdokumentation" wird ein Report mit allen Seiten-Elementen sowie den zugeh\00F6rigen Entwicklerkommentaren eingeblendet.'),
'@optimieren: Such-Collection nur dann anlegen, wenn Ergebnisse vorliegen (betrifft: erfolglose Adressensuche)'))
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(214963319153211520)
,p_plug_name=>'Monitoring: QUERY_STRING'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_plug_source=>'htp.p(''<pre>'' || :P4_QUERY_STRING || ''</pre>'');'
,p_plug_source_type=>'NATIVE_PLSQL'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_plug_comment=>unistr('Nur f\00FCr das Monitoring: Zeigt das SQL an, das dem Report zugrundeliegt')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(214963425286211521)
,p_plug_name=>'Monitoring'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>60
,p_include_in_reg_disp_sel_yn=>'Y'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('Hilfestellungen f\00FCr das Debuggen der Seite. Build Option "Monitoring" einschalten.')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(211588249965690602)
,p_plug_name=>'P4_CHECKBOX'
,p_parent_plug_id=>wwv_flow_imp.id(214963425286211521)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SEQ_ID, N001, N002, C001',
' FROM APEX_COLLECTIONS WHERE COLLECTION_NAME = ''P4_CHECKBOX'''))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'P4_CHECKBOX'
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
,p_plug_comment=>'Inhalt der APEX_COLLECTION P4_CHECKBOX'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(214605497415121220)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_LEFT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>49689636325038544
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214605660079121221)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Seq Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214605663474121222)
,p_db_column_name=>'N001'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'N001'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214605766275121223)
,p_db_column_name=>'N002'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'N002'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214605927863121224)
,p_db_column_name=>'C001'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'C001'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(214650051600215167)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'497342'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ_ID:N001:N002:C001'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(214960494868211492)
,p_plug_name=>'Adressen Monitoring'
,p_parent_plug_id=>wwv_flow_imp.id(214963425286211521)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SEQ_ID, C001, C002, C003, C004, C005, C006, C007, C008, C009, C010, C011, C012, C013, C014, C015, C016, C017, C018, C019, C020',
'  FROM APEX_COLLECTIONS WHERE COLLECTION_NAME LIKE ''P4%'' AND COLLECTION_NAME <> ''P4_CHECKBOX'''))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Adressen Monitoring'
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
,p_plug_comment=>'Inhalt aller Collections, deren Name mit P4 beginnt (aber nicht die Checkboxen-Collection).'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(214960572212211493)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_LEFT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>50044711122128817
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214960699040211494)
,p_db_column_name=>'SEQ_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Seq Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214960775235211495)
,p_db_column_name=>'C001'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'C001'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214960937422211496)
,p_db_column_name=>'C002'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'C002'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214960973451211497)
,p_db_column_name=>'C003'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'C003'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961093541211498)
,p_db_column_name=>'C004'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'C004'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961240504211499)
,p_db_column_name=>'C005'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'C005'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961328907211500)
,p_db_column_name=>'C006'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'C006'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961438662211501)
,p_db_column_name=>'C007'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'C007'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961485089211502)
,p_db_column_name=>'C008'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'C008'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961565625211503)
,p_db_column_name=>'C009'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'C009'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961724835211504)
,p_db_column_name=>'C010'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'C010'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961802321211505)
,p_db_column_name=>'C011'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'C011'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214961930814211506)
,p_db_column_name=>'C012'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'C012'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962054951211507)
,p_db_column_name=>'C013'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'C013'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962106581211508)
,p_db_column_name=>'C014'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'C014'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962172226211509)
,p_db_column_name=>'C015'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'C015'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962313500211510)
,p_db_column_name=>'C016'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'C016'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962401335211511)
,p_db_column_name=>'C017'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'C017'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962530135211512)
,p_db_column_name=>'C018'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'C018'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962651317211513)
,p_db_column_name=>'C019'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'C019'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962738450211514)
,p_db_column_name=>'C020'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'C020'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(215067836725980979)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'501520'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'SEQ_ID:C001:C002:C003:C004:C005:C006:C007:C008:C009:C010:C011:C012:C013:C014:C015:C016:C017:C018:C019:C020'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(214963602004211523)
,p_name=>'Collections-Auflistung'
,p_parent_plug_id=>wwv_flow_imp.id(214963425286211521)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>50
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COLLECTION_NAME, COUNT(*)',
'  FROM APEX_COLLECTIONS',
' GROUP BY COLLECTION_NAME',
' ORDER BY 2 DESC'))
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
,p_comment=>'Die Namen aller auf der Seite aktuell existierenden Collections'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(214963742002211524)
,p_query_column_id=>1
,p_column_alias=>'COLLECTION_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Collection Name'
,p_column_html_expression=>'<pre>#COLLECTION_NAME#</pre>'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(214963834118211525)
,p_query_column_id=>2
,p_column_alias=>'COUNT(*)'
,p_column_display_sequence=>20
,p_column_heading=>'Count(*)'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(216061431093669188)
,p_plug_name=>'Bedingtes CSS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236526213069961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_point=>'REGION_POSITION_01'
,p_plug_source=>'#adressenIR #adressenIR_control_panel {display:none}'
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_plug_display_when_cond2=>'1'
,p_plug_header=>'<style>'
,p_plug_footer=>'</style>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('Blendet das Kontroll-Bedienfeld des Reports aus, wenn dieser sich im Modus "Ausgew\00E4hlte Adressen pr\00FCfen" befindet, damit der Benutzer nicht auf die Idee kommt, hier gro\00DFartig etwas zu \00E4ndern')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(216061568119669190)
,p_plug_name=>'Entwicklerdokumentation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>70
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'SQL'
,p_plug_source=>'SELECT * FROM APEX_COCONUT WHERE WORKSPACE = ''ROMA'' AND APPLICATION_ID = :APP_ID AND PAGE_ID = :APP_PAGE_ID'
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Entwicklerdokumentation'
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
,p_required_patch=>wwv_flow_imp.id(217573164052110420)
,p_plug_comment=>'Zeigt die Seitenelemente und deren Kommentare an. Build Option "Entwicklerdokumentation" einschalten.'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(216061712904669191)
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
,p_internal_uid=>51145851814586515
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062196609669196)
,p_db_column_name=>'KATEGORIE_NR'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Kategorie Nr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062296131669197)
,p_db_column_name=>'VIEW_NAME'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'View Name'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062384916669198)
,p_db_column_name=>'COMPONENT'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Component'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062501150669199)
,p_db_column_name=>'TYPE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062597636669200)
,p_db_column_name=>'EXTRA'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Extra'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062704030669201)
,p_db_column_name=>'ID'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Id'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062770021669202)
,p_db_column_name=>'SEQ'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Seq'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062951916669203)
,p_db_column_name=>'NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216062989131669204)
,p_db_column_name=>'PAYLOAD'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Label / Inhalt'
,p_column_html_expression=>'<pre>#PAYLOAD#</pre>'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063088541669205)
,p_db_column_name=>'CONDITION'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Condition'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063227819669206)
,p_db_column_name=>'CONDITION_TYPE_CODE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Condition Type Code'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063340106669207)
,p_db_column_name=>'CONDITION_EXPRESSION1'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Condition Expression1'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063449686669208)
,p_db_column_name=>'CONDITION_EXPRESSION2'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Condition Expression2'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063518055669209)
,p_db_column_name=>'BUILD_OPTION'
,p_display_order=>180
,p_column_identifier=>'R'
,p_column_label=>'Build Option'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063654737669210)
,p_db_column_name=>'BUILD_OPTION_STATUS'
,p_display_order=>190
,p_column_identifier=>'S'
,p_column_label=>'Build Option Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063746280669211)
,p_db_column_name=>'AUTHORIZATION_SCHEME'
,p_display_order=>200
,p_column_identifier=>'T'
,p_column_label=>'Authorization Scheme'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063795407669212)
,p_db_column_name=>'COMMENTS'
,p_display_order=>210
,p_column_identifier=>'U'
,p_column_label=>'Comments'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216063954175669213)
,p_db_column_name=>'LAST_UPDATED_BY'
,p_display_order=>220
,p_column_identifier=>'V'
,p_column_label=>'Last Updated By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216064046781669214)
,p_db_column_name=>'LAST_UPDATED_ON'
,p_display_order=>230
,p_column_identifier=>'W'
,p_column_label=>'Last Updated On'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(217581786948127210)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'526660'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>100000
,p_report_columns=>'COMPONENT:TYPE:NAME:COMMENTS:PAYLOAD:'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217602472481426212)
,p_report_id=>wwv_flow_imp.id(217581786948127210)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'COMPONENT'
,p_operator=>'not like'
,p_expr=>'%Report Column'
,p_condition_sql=>'"COMPONENT" not like #APXWS_EXPR#'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME# ''%Report Column''  '
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217602896856426212)
,p_report_id=>wwv_flow_imp.id(217581786948127210)
,p_name=>'ohne NEVER'
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_expr_type=>'ROW'
,p_expr=>'NVL(O, ''-'') <> ''NEVER'''
,p_condition_sql=>'NVL("CONDITION_TYPE_CODE", ''-'') <> ''NEVER'''
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217603357171426212)
,p_report_id=>wwv_flow_imp.id(217581786948127210)
,p_name=>'Ohne Build Option "Excluded"'
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_expr_type=>'ROW'
,p_expr=>'NVL(R, ''-'') <> ''Exclude'''
,p_condition_sql=>'NVL("BUILD_OPTION", ''-'') <> ''Exclude'''
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(284349974215256366)
,p_plug_name=>unistr('Adressen (ausgew\00E4hlt: <span id="num_checked">&P4_NUM_CHECKED.</span>)')
,p_icon_css_classes=>'fa-home'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>40
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_display_condition_type=>'ITEM_IS_NOT_ZERO'
,p_plug_display_when_condition=>'P4_DO_SEARCH'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('\00DCberschrift des Adressen-Reports. Zeigt die Anzahl der ausgew\00E4hlten Adressen an (diese Zahl wird durch Dynamic Actions bei jedem Klick auf eine checkbox aktualisiert)')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(209052772198315201)
,p_plug_name=>'Adressen IR'
,p_region_name=>'adressenIR'
,p_parent_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'FUNC_BODY_RETURNING_SQL'
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_QUERY_STRING :=',
unistr('-- APEX ADVISOR SCHL\00C4GT HIER FEHLALARM --------------'),
'PCK_VERMARKTUNGSCLUSTER.fv_query_p4_collection(',
'        pin_ausbaugebiet       => :P4_SEARCH_GEBIET,',
'        piv_ausbaugebiet_typ   => :P4_SEARCH_TYP,',
'        piv_adresse            => :P4_SEARCH_ALL,',
'        pin_vc_lfd_nr          => :P4_VC_ID,',
'        pib_auswahl_bearbeiten => CASE WHEN :P4_AUSWAHL_BEARBEITEN = 1 THEN TRUE END',
');',
'RETURN :P4_QUERY_STRING;',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P4_QUERY_STRING,P4_SEARCH_GEBIET,P4_SEARCH_TYP,P4_SEARCH_ALL,P4_VC_ID,P4_AUSWAHL_BEARBEITEN'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Adressen IR'
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
unistr('Report mit den Kandidaten f\00FCr die Cluster-Zuordnung. Das SQL wird dynamisch vom PCK_VERMARKTUNGSCLUSTER generiert und an den Report zur\00FCckgegeben. P4_DO_SEARCH wird nicht mehr als Parameter ben\00F6tigt, da der Report sowieso nur abgerufen wird, wenn das')
||' Page Item P4_DO_SEARCH auf 1 steht.',
'Der Report ruft seine Daten aus diversen APEX_COLLECTIONS ab: Zu jeder Kombination aus Ausbaugebiet (P4_SEARCH_GEBIET) und Ausbaugebiet-Typ (P4_SEARCH_TYP) wird eine eigene APEX-Collection angelegt, deren Name durch einen Parameter-Hash generiert wir'
||unistr('d (siehe PCK_VERMARKTUNGSCLUSTER.fv_query_p4_collection, #HASHED_COLLECTION_NAME, Beispiel: ''P4_FD9B22ABE1021DE18D0B833FC49A7369''). Dadurch werden sowohl das erneute Aufrufen des Reports, aber vor allem das Umbl\00E4ttern in den Ergebnissen erheblich bes')
||unistr('chleunigt. Nach dem Zuordnen der ausgew\00E4hlten Zeilen werden diese Collections sofort gel\00F6scht.')))
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(209052942709315202)
,p_max_row_count=>'40000'
,p_max_row_count_message=>unistr('Es sind mehr Ergebnisse vorhanden als sinnvollerweise zugleich angezeigt werden k\00F6nnen.')
,p_no_data_found_message=>'Keine Adressen gefunden'
,p_pagination_type=>'ROWS_X_TO_Y_OF_Z'
,p_pagination_display_pos=>'TOP_AND_BOTTOM_LEFT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_computation=>'N'
,p_show_aggregate=>'N'
,p_show_chart=>'N'
,p_show_group_by=>'N'
,p_show_pivot=>'N'
,p_show_flashback=>'N'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'WISAND'
,p_internal_uid=>44137081619232526
);
wwv_flow_imp_page.create_worksheet_col_group(
 p_id=>wwv_flow_imp.id(214958996134211477)
,p_name=>'GEE'
,p_display_sequence=>10
);
wwv_flow_imp_page.create_worksheet_col_group(
 p_id=>wwv_flow_imp.id(214959149439211478)
,p_name=>'Netzbau'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214959801220211485)
,p_db_column_name=>'ID'
,p_display_order=>10
,p_column_identifier=>'T'
,p_column_label=>'Id'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962781585211515)
,p_db_column_name=>'CHECKBOX_AUSWAHL'
,p_display_order=>20
,p_column_identifier=>'Z'
,p_column_label=>unistr('<input type="checkbox" value="0" id="header_checkbox" title="Setzt oder entfernt die Auswahl-H\00E4kchen aller Zeilen, die momentan auf dieser Seite der Ergebnisliste zu sehen sind">')
,p_allow_sorting=>'N'
,p_allow_filtering=>'N'
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
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
,p_column_comment=>unistr('Im Header dient die Checkbox dazu, alle Zeilen-Checkboxen zu aktivieren oder deaktiviern. Die Checkbox jeder einzelnen Zeile bekommt ihre Klasse ("checkbox--ir") aus dem SQL des Reports (siehe Report-Definition => PCK_VERMARKTUNGSCLUSTER); ben\00F6tigt w')
||unistr('ird diese f\00FCr die Dynamic Action')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(216061347183669187)
,p_db_column_name=>'CHECKED'
,p_display_order=>30
,p_column_identifier=>'AC'
,p_column_label=>'Checked'
,p_allow_highlighting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
,p_column_comment=>unistr('Flag: 1, wenn die Adresse ausgew\00E4hlt ist. Gibt dem Benutzer die M\00F6glichkeit der Filterung (da die zugeh\00F6rige Checkbox ein nicht filterbares HTML-Konstrukt ist)')
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(209052966448315203)
,p_db_column_name=>'GEBIET'
,p_display_order=>50
,p_column_identifier=>'A'
,p_column_label=>'Gebiet'
,p_allow_ctrl_breaks=>'N'
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
 p_id=>wwv_flow_imp.id(209053157379315204)
,p_db_column_name=>'TYP'
,p_display_order=>60
,p_column_identifier=>'B'
,p_column_label=>'Typ'
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
 p_id=>wwv_flow_imp.id(214959167910211479)
,p_db_column_name=>'VERMARKTUNGSCLUSTER'
,p_display_order=>70
,p_column_identifier=>'S'
,p_column_label=>'im Vermarktungscluster'
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
 p_id=>wwv_flow_imp.id(214960146828211488)
,p_db_column_name=>'HAUS_LFD_NR'
,p_display_order=>80
,p_column_identifier=>'W'
,p_column_label=>'Haus Lfd Nr'
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
 p_id=>wwv_flow_imp.id(209053527495315208)
,p_db_column_name=>'STR'
,p_display_order=>90
,p_column_identifier=>'F'
,p_column_label=>unistr('Stra\00DFe')
,p_allow_ctrl_breaks=>'N'
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
 p_id=>wwv_flow_imp.id(209053711821315210)
,p_db_column_name=>'HNR_ZUS'
,p_display_order=>100
,p_column_identifier=>'H'
,p_column_label=>'Zus.'
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
 p_id=>wwv_flow_imp.id(214959877344211486)
,p_db_column_name=>'PLZ'
,p_display_order=>110
,p_column_identifier=>'U'
,p_column_label=>'PLZ'
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
 p_id=>wwv_flow_imp.id(209053286735315206)
,p_db_column_name=>'ORT'
,p_display_order=>120
,p_column_identifier=>'D'
,p_column_label=>'Ort'
,p_allow_ctrl_breaks=>'N'
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
 p_id=>wwv_flow_imp.id(214960247708211489)
,p_db_column_name=>'WE_GES'
,p_display_order=>130
,p_column_identifier=>'X'
,p_column_label=>'WE gesamt'
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
 p_id=>wwv_flow_imp.id(209054055806315213)
,p_db_column_name=>'DNSTTP_BEZ'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Technologie'
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
 p_id=>wwv_flow_imp.id(209054079664315214)
,p_db_column_name=>'GEE_STATUS'
,p_display_order=>150
,p_group_id=>wwv_flow_imp.id(214958996134211477)
,p_column_identifier=>'L'
,p_column_label=>'GEE Status'
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
 p_id=>wwv_flow_imp.id(209054556258315218)
,p_db_column_name=>'AUSBAUSTATUS'
,p_display_order=>160
,p_group_id=>wwv_flow_imp.id(214959149439211478)
,p_column_identifier=>'P'
,p_column_label=>'Ausbaustatus'
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
 p_id=>wwv_flow_imp.id(214959965796211487)
,p_db_column_name=>'HNR'
,p_display_order=>170
,p_column_identifier=>'V'
,p_column_label=>'Hnr'
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
 p_id=>wwv_flow_imp.id(214960293877211490)
,p_db_column_name=>'BEREITS_ZUGEORDNET'
,p_display_order=>180
,p_column_identifier=>'Y'
,p_column_label=>'Bereits Zugeordnet'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
,p_column_comment=>'Flag: 1, wenn die Adresse dem auf der Seite angezeigten Vermarktungscluster bereits zugeordnet ist'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(214962874159211516)
,p_db_column_name=>'GEE_ERTEILT_AM'
,p_display_order=>190
,p_column_identifier=>'AA'
,p_column_label=>'erteilt'
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
 p_id=>wwv_flow_imp.id(214962965839211517)
,p_db_column_name=>'TERMIN'
,p_display_order=>200
,p_column_identifier=>'AB'
,p_column_label=>'Termin'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_column_alignment=>'CENTER'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(211509241773515013)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'SUCHE'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'CHECKBOX_AUSWAHL:GEBIET:TYP:HAUS_LFD_NR:VERMARKTUNGSCLUSTER:PLZ:ORT:STR:HNR:HNR_ZUS:DNSTTP_BEZ:WE_GES:GEE_STATUS:GEE_ERTEILT_AM:AUSBAUSTATUS:TERMIN:'
,p_sort_column_1=>'PLZ'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ORT'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'STR'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'HNR'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'HNR_ZUS'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'HAUS_LFD_NR'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(222230719708414287)
,p_report_id=>wwv_flow_imp.id(211509241773515013)
,p_name=>'bereits zugeordnet'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'='
,p_expr=>'1'
,p_condition_sql=>' (case when ("BEREITS_ZUGEORDNET" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''1''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#d0f1cc'
,p_row_font_color=>'#767676'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(217470448294691644)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>unistr('Ausgew\00E4hlte Adressen')
,p_report_seq=>10
,p_report_alias=>'AUSWAHL'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'CHECKBOX_AUSWAHL:HAUS_LFD_NR:VERMARKTUNGSCLUSTER:PLZ:ORT:STR:HNR:HNR_ZUS:'
,p_sort_column_1=>'PLZ'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ORT'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'STR'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'HNR'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'HNR_ZUS'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'HAUS_LFD_NR'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217610801693499840)
,p_report_id=>wwv_flow_imp.id(217470448294691644)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'is null'
,p_condition_sql=>'"BEREITS_ZUGEORDNET" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217611172042499840)
,p_report_id=>wwv_flow_imp.id(217470448294691644)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'CHECKED'
,p_operator=>'='
,p_expr=>'1'
,p_condition_sql=>'"CHECKED" = to_number(#APXWS_EXPR#)'
,p_condition_display=>'#APXWS_COL_NAME# = #APXWS_EXPR_NUMBER#  '
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(217567202770008161)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'ohne bereits Zugeordnete'
,p_report_seq=>10
,p_report_alias=>'NICHT_ZUGEORDNET'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'CHECKBOX_AUSWAHL:GEBIET:TYP:HAUS_LFD_NR:VERMARKTUNGSCLUSTER:PLZ:ORT:STR:HNR:HNR_ZUS:DNSTTP_BEZ:WE_GES:GEE_STATUS:GEE_ERTEILT_AM:AUSBAUSTATUS:TERMIN:'
,p_sort_column_1=>'PLZ'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ORT'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'STR'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'HNR'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'HNR_ZUS'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'HAUS_LFD_NR'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217610203742495899)
,p_report_id=>wwv_flow_imp.id(217567202770008161)
,p_name=>'bereits zugeordnet'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'='
,p_expr=>'1'
,p_condition_sql=>' (case when ("BEREITS_ZUGEORDNET" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''1''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#d0f1cc'
,p_row_font_color=>'#767676'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(217609838534495899)
,p_report_id=>wwv_flow_imp.id(217567202770008161)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'is null'
,p_condition_sql=>'"BEREITS_ZUGEORDNET" is null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(222375431852493557)
,p_application_user=>'APXWS_ALTERNATIVE'
,p_name=>'nur bereits Zugeordnete'
,p_report_seq=>10
,p_report_alias=>'ZUGEORDNET'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>1000
,p_report_columns=>'CHECKBOX_AUSWAHL:GEBIET:TYP:HAUS_LFD_NR:VERMARKTUNGSCLUSTER:PLZ:ORT:STR:HNR:HNR_ZUS:DNSTTP_BEZ:WE_GES:GEE_STATUS:GEE_ERTEILT_AM:AUSBAUSTATUS:TERMIN:'
,p_sort_column_1=>'PLZ'
,p_sort_direction_1=>'ASC'
,p_sort_column_2=>'ORT'
,p_sort_direction_2=>'ASC'
,p_sort_column_3=>'STR'
,p_sort_direction_3=>'ASC'
,p_sort_column_4=>'HNR'
,p_sort_direction_4=>'ASC'
,p_sort_column_5=>'HNR_ZUS'
,p_sort_direction_5=>'ASC'
,p_sort_column_6=>'HAUS_LFD_NR'
,p_sort_direction_6=>'ASC'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(222377524378495360)
,p_report_id=>wwv_flow_imp.id(222375431852493557)
,p_name=>'bereits zugeordnet'
,p_condition_type=>'HIGHLIGHT'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'='
,p_expr=>'1'
,p_condition_sql=>' (case when ("BEREITS_ZUGEORDNET" = #APXWS_EXPR#) then #APXWS_HL_ID# end) '
,p_condition_display=>'#APXWS_COL_NAME# = ''1''  '
,p_enabled=>'Y'
,p_highlight_sequence=>10
,p_row_bg_color=>'#d0f1cc'
,p_row_font_color=>'#767676'
);
wwv_flow_imp_page.create_worksheet_condition(
 p_id=>wwv_flow_imp.id(222377135084495359)
,p_report_id=>wwv_flow_imp.id(222375431852493557)
,p_condition_type=>'FILTER'
,p_allow_delete=>'Y'
,p_column_name=>'BEREITS_ZUGEORDNET'
,p_operator=>'is not null'
,p_condition_sql=>'"BEREITS_ZUGEORDNET" is not null'
,p_condition_display=>'#APXWS_COL_NAME# #APXWS_OP_NAME#'
,p_enabled=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(284350265811256369)
,p_plug_name=>'P4_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>'Nicht angezeigte Region mit Hidden Page-Items'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(284354298307256410)
,p_plug_name=>'Hilfe'
,p_region_template_options=>'#DEFAULT#:js-dialog-size720x480'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236551834480961953)
,p_plug_display_sequence=>50
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_source=>'htp.p(pck_strav_query.fcl_adress_where_query_help)'
,p_plug_source_type=>'NATIVE_PLSQL'
,p_plug_comment=>'Benutzerhilfe zur Adresssuche'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(292247675037062612)
,p_plug_name=>'Ausbaugebiet'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(295725840141210281)
,p_plug_name=>'Adressensuche'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_plug_display_condition_type=>'ITEM_IS_NULL'
,p_plug_display_when_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(306692355312967806)
,p_plug_name=>unistr('Vermarktungscluster <b>&P4_VC_NAME.</b> - Objekte hinzuf\00FCgen')
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
 p_id=>wwv_flow_imp.id(211460736232287018)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(295725840141210281)
,p_button_name=>'BTN_SEARCH'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Suchen'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-search'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>2
,p_button_comment=>'Startet die Adresssuche'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211461121563287018)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(295725840141210281)
,p_button_name=>'BTN_SEARCH_INFO'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236621410242961984)
,p_button_image_alt=>'Hilfe zur Adressensuche'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-question-circle-o'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_grid_column_span=>1
,p_button_comment=>unistr('\00D6ffnet den Dialog mit der Benutzerhilfe zur Adresssuche')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211459207858287014)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(292247675037062612)
,p_button_name=>'BTN_KOMPLETTES_GEBIET_ZUORDNEN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'&P4_FILTER_NAME. komplett zuordnen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_SEARCH_GEBIET IS NOT NULL OR',
':P4_SEARCH_TYP IS NOT NULL'))
,p_button_condition2=>'SQL'
,p_button_condition_type=>'EXPRESSION'
,p_icon_css_classes=>'fa-badge-check'
,p_button_comment=>unistr('Ordnet dem aktuellen Vermarktungscluster alle Objekte (HAUS_LFD_NRn) zu, die sich in der aktuell ausgew\00E4hlten Kombi von "Ausbaugebiet" und "Ausbaugebiet Typ" befinden (unabh\00E4ngig von ihrer Adresse, ob deren Auswahl-H\00E4kchen gesetzt ist oder auf welche')
||'r Seite der Pagination sie stehen).'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(214963523741211522)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(214963319153211520)
,p_button_name=>'MON_RESET_AUSWAHL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'RESET AUSWAHL'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.:RESET:&DEBUG.:::'
,p_button_comment=>'Leert die Checkboxen-Collection'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(214963949031211526)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(214963319153211520)
,p_button_name=>'MON_RESET_ALLE_COLLECTIONS'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'RESET ALLE COLLECTIONS'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:4:&SESSION.:RESET_ALLE_COLLECTIONS:&DEBUG.:::'
,p_button_comment=>'Leert alle Collections, die mit P4_... beginnen'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(216064119113669215)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(214963319153211520)
,p_button_name=>'MON_LOESCHE_BESTEHENDE_ZUORDNUNGEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>unistr('L\00F6sche alle bestehenden Zuordnungen')
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_button_comment=>unistr('Zerst\00F6rt alle bestehenden Zuordnungen zum Vermarktungscluster! Dieser Button ist nur f\00FCr die Entwicklung erlaubt und sollte auch dann nur mit \00E4u\00DFerster Sorgfalt eingesetzt werden: Der Vermarktungscluster muss mit dem String "Test" beginnen.')
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(211462587270287019)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(306692355312967806)
,p_button_name=>'BTN_ZUORDNUNGEN_SPEICHERN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Ausgew\00E4hlte Adressen zuordnen')
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-save'
,p_button_comment=>'Ordnet alle in der Collection P4_CHECKBOX mit N001 = 1 gespeicherten HAUS_LFD_NRn dem aktuellen Vermarktungscluster zu.'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(216064641874669220)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_button_name=>'BTN_ALLE_ERGEBNISSE_AUSWAEHLEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('S\00E4mtliche Ergebnisse ausw\00E4hlen')
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-table-check'
,p_button_cattributes=>unistr('title="F\00FCgt alle Adressen, die durch &quot;Ausbaugebiet&quot;, &quot;Ausbaugebiet Typ&quot; und &quot;Adresssuche&quot; definiert sind, zur bestehenden Auswahl hinzu &ndash; auch wenn sie in der aktuellen Seitenaufteilung des Reports nicht sichtbar s')
||'ind"'
,p_button_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Dieser Button ist #disabled: Es kann nur dann funktionieren, wenn sichergestellt w\00E4re, dass der Benutzer entweder keinen zus\00E4tzlichen Filter auf den Report gelegt hat, oder man diesen Filter auslesen k\00F6nnte (was nicht der Fall ist, daf\00FCr existiert de')
||unistr('rzeit keine API) /// pr\00FCfen, ob das mit APEX 22.2 immer noch gilt'),
'',
unistr('\00C4hnlich der Funktion "Komplettes Gebiet zuordnen". Jedoch wird hier der gesamte Report, welcher durch die Selectlisten "Ausbaugebiet", "Ausbaugebiet Typ" bzw. "Adresse" definiert ist, zur Auswahl hinzugef\00FCgt. Im Unterschied zur Header-Checkbox umfass')
||'t das auch diejenigen Zeilen, die in der aktuellen Pagination gar nicht zu sehen sind.'))
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(216064416849669218)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_button_name=>'BTN_AUSWAHL_LOESCHEN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('Gesamte Auswahl zur\00FCcksetzen')
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-table-x'
,p_button_cattributes=>unistr('title="Entfernt alle von Ihnen gesetzten Auswahl-H\00E4kchen, inklusive derjenigen, die auf der aktuellen Seite der Ergebnisliste nicht zu sehen sind &ndash; so dass die Auswahl wieder auf &quot;0 Adressen&quot; steht"')
,p_button_comment=>unistr('Der Benutzer kann eine bereits get\00E4tigte (z.B. sehr umfangreiche) Auswahl durch Klick auf diesen Button wieder komplett l\00F6schen')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(214959356412211480)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_button_name=>'BTN_AUSWAHL_BEARBEITEN'
,p_button_static_id=>'BTN_AUSWAHL_BEARBEITEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('Auswahl \00FCberpr\00FCfen ...')
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-table-search'
,p_button_cattributes=>unistr('title="Zeigt ausschlie\00DFlich diejenigen Adressen an, die von Ihnen ausgew\00E4hlt wurden"')
,p_button_comment=>unistr('Durch Anklicken wird P4_AUSWAHL_BEARBEITEN auf 1 gesetzt (dadurch schaltet der Report um und zeigt nur die bereits ausgew\00E4hlten Adressen an, au\00DFerdem werden die Filter-Regionen oberhalb des Report ausgeblendet)')
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(214959560548211482)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_button_name=>'BTN_AUSWAHL_BEARBEITEN_BEENDEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Zur\00FCck zur Suche')
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P4_AUSWAHL_BEARBEITEN'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-map-markers-o'
,p_button_comment=>'Durch Anklicken wird P4_AUSWAHL_BEARBEITEN wieder auf NULL gesetzt (dadurch schaltet die Seite auf Normaldarstellung um)'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(216060523025669179)
,p_branch_name=>'BTN_AUSWAHL_BEARBEITEN'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.:IR[adressenIR]_AUSWAHL:&DEBUG.:RP,::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(214959356412211480)
,p_branch_sequence=>10
,p_branch_comment=>unistr('Das Bearbeiten der ausgew\00E4hlten Adressen setzt voraus, dass der Interactive Report auf "AUSWAHL" umgeschaltet wird. Pagination wird auf 1 zur\00FCckgesetzt')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(216060619711669180)
,p_branch_name=>'BTN_AUSWAHL_BEARBEITEN_BEENDEN'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.:IR[adressenIR]_SUCHE:&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(214959560548211482)
,p_branch_sequence=>20
,p_branch_comment=>unistr('Das Zur\00FCckschalten auf die Standard-Adressensuche setzt voraus, dass der Interactive Report wieder auf den Prim\00E4ren Report "SUCHE" zur\00FCckgesetzt wird. Kein Zur\00FCcksetzen der Pagination, da alle zuvor dargestellten Adressen ja weiterhin vorliegen.')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(216061489858669189)
,p_branch_name=>'BTN_ZUORDNUNGEN_SPEICHERN'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.:IR[adressenIR]_SUCHE:&DEBUG.:RP,::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(211462587270287019)
,p_branch_sequence=>30
,p_branch_comment=>unistr('Nach der Zuordnung den Interactive Report wieder auf den Prim\00E4ren Report "SUCHE" zur\00FCcksetzen und die Pagination auf 1 stellen')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(216061046351669184)
,p_branch_name=>'Reset Pagination (Adressen-Report)'
,p_branch_action=>'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:RP,::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>40
,p_branch_condition_type=>'REQUEST_IN_CONDITION'
,p_branch_condition=>'P4_SEARCH_GEBIET, P4_SEARCH_TYP, BTN_SEARCH'
,p_branch_comment=>unistr('Nach dem Umschalten einer der beiden Selectlisten oder Klick auf den Adresssuche-Button (Lupen-Symbol) muss der Interaktive Report auf Seite 1 zur\00FCckgestellt werden, da der Benutzer ansonsten eine Fehlermeldung erh\00E4lt, wenn in der neuen Ergebnismenge')
||' weniger Zeilen enthalten sind als zuvor'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211459647927287014)
,p_name=>'P4_SEARCH_GEBIET'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(292247675037062612)
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
,p_cHeight=>1
,p_tag_css_classes=>'filterItem'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Benutzerauswahl f\00FCr das Ausbaugebiet.'),
'@ticket FTTH-3247'))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211459983287287017)
,p_name=>'P4_SEARCH_TYP'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(292247675037062612)
,p_prompt=>'Ausbaugebiet-Typ'
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
,p_cHeight=>1
,p_tag_css_classes=>'filterItem'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'NO'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>unistr('Benutzerauswahl f\00FCr den Ausbaugebiet-Typ')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211461524948287018)
,p_name=>'P4_DO_SEARCH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(284350265811256369)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Flag, wird im Pre-Rendering gesetzt. ',
unistr('1= Adressen-Report soll dargestellt werden. Wird im Gegensatz zur fr\00FCheren Seite P7 nicht mehr an die Report-Engine gesendet, da diese selbst entscheidet, ob eine Suche stattfindet.')))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211461903297287018)
,p_name=>'P4_SEARCH_ALL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(295725840141210281)
,p_prompt=>'Suchen nach'
,p_placeholder=>'Adresse oder Adressbestandteil eingeben ...'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_tag_css_classes=>'filterItem'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_item_comment=>unistr('Eingabefeld f\00FCr die Adressensuche')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211463291728287019)
,p_name=>'P4_VC_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(284350265811256369)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('\00DCberschrift: Namen des Vermakrtungsclusters anzeigen. Wird im Pre-Rendering gesetzt.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211463706367287020)
,p_name=>'P4_VC_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(284350265811256369)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_item_comment=>unistr('ID des Vermarktungsclusters, auf den sich alle Aktionen auf dieser Seite beziehen (h\00E4tte besser P4_VC_LFD_NR hei\00DFen sollen)')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(211588085480690601)
,p_name=>'P4_NUM_CHECKED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert, wie viele Checkboxen im aktuell angezeigten Report angehakt sind. Diese Zahl erscheint in der \00DCberschrift der Adressen-Region.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(214959413389211481)
,p_name=>'P4_AUSWAHL_BEARBEITEN'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Flag. Wenn 1, schaltet der Report um und zeigt nur die bereits ausgew\00E4hlten Adressen an, au\00DFerdem werden die Filter-Regionen oberhalb des Report ausgeblendet. '),
unistr('Der alternative Wert des Flags ist NULL. Nicht verwendet werden sollte FALSE, da dies den Vergleich unn\00F6tig verkompliziert.')))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(214963122219211518)
,p_name=>'P4_QUERY_STRING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(284349974215256366)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Speichert den vom Adressen-Report verwendeten SQL Query String. Dies ist hilfreich, wenn Build Option "Monitoring" eingeschaltet ist. Das Item darf nicht gel\00F6scht werden, da die Report-Abfrage dies ben\00F6tigt.')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(216061086388669185)
,p_name=>'P4_ANZAHL_OBJEKTE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(292247675037062612)
,p_prompt=>'P4_ANZAHL_OBJEKTE'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_item_comment=>'Speichert beim Klicken des Buttons "Komplettes Gebiet zuordnen" die Anzahl der zuordenbaren Objekte'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(216064821717669222)
,p_name=>'P4_FILTER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(284350265811256369)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Gibt an, mit welchem Filterkriterium gesucht wird.',
unistr('Zur Zeit gilt "entweder oder": Nur eines dieser Kriterien wird ber\00FCcksichtigt:'),
unistr('0 = keine Sucheingabe get\00E4tigt'),
unistr('1 = Suche \00FCber Ausbaugebiet'),
unistr('2 = Suche \00FCber Ausbaugebiet Typ'),
unistr('4 = Suche \00FCber Adresse, "Adresssuche"'),
unistr('Die Werte sind Zweiterpotenzen, damit zuk\00FCnftig auch eine kombinierte Suche m\00F6glich w\00E4re'),
unistr('(z.B. 3 = Ausbaugebiet OR Typ, -3 = Ausbaugebiet AND Typ, 7 = alle Treffer kombinieren) ohne daf\00FCr bestehenden Code umschreiben zu m\00FCssen.')))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(220171914266178278)
,p_name=>'P4_FILTER_NAME'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(284350265811256369)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Abh\00E4ngig von P4_FILTER steht in diesem Item die Bezeichnung des Filters, damit diese im Label des Buttons BTN_KOMPLETTES_GEBIET_ZUORDNEN eingef\00FCgt werden kann.')
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(211464528782287032)
,p_computation_sequence=>10
,p_computation_item=>'P4_VC_NAME'
,p_computation_point=>'BEFORE_BOX_BODY'
,p_computation_type=>'QUERY'
,p_computation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select bezeichnung ',
'  from VERMARKTUNGSCLUSTER',
'  where vc_lfd_nr =  :P4_VC_ID'))
,p_computation_comment=>unistr('Name des Vermarktungsclusters f\00FCr die \00DCberschrift der Seite')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(211471497562287039)
,p_name=>'Search Hilfe anzeigen'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(211461121563287018)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('\00D6ffnet den Dialog mit der Benutzerhilfe zum Thema "Adresssuche"')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(211472044673287039)
,p_event_id=>wwv_flow_imp.id(211471497562287039)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(284354298307256410)
,p_da_action_comment=>unistr('\00D6ffnet den Dialog mit der Benutzerhilfe zum Thema "Adresssuche"')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(211585835425690578)
,p_name=>'Checkbox Header'
,p_event_sequence=>130
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#header_checkbox'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#adressenIR'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('Reagiert auf den Klick des Benutzers auf die Checkbox in der Report-Headerzeile: Setzt oder entfernt alle sichtbaren H\00E4kchen. Wenn durch Pagination beispielsweise nur 1000 Zeilen im Report angezeigt werden, dann werden auch nur H\00E4kchen f\00FCr maximal 10')
||'00 neue Zuordnungskandidaten generiert.'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(211585917688690579)
,p_event_id=>wwv_flow_imp.id(211585835425690578)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'spinner = apex.util.showSpinner();',
'',
'let checkboxHeader = this.triggeringElement;',
'let headerIsCheckedByUser = checkboxHeader.checked;',
'checkboxHeader.checked = !headerIsCheckedByUser;',
'',
'let $affectedCheckboxes = $(''#adressenIR input.checkbox--ir:'' + (headerIsCheckedByUser ? ''not(checked)'' : ''checked'') );',
'',
'',
'let maxParameterLength = 32767; // Grenze in PL/SQL',
'var currentParameterLength = 0;',
unistr('var checklist = [undefined,[],[],[],[],[],[],[],[],[],[]]; // M\00F6glichst viele (10) gro\00DFe Listen an PL/SQL \00FCbergeben k\00F6nnen (checklist[0] wird nicht verwendet)'),
'var numberOfCheckboxes = 0;',
'var tooManyCheckboxes = false;',
'var currentArray = 1;',
'',
'$affectedCheckboxes.each(function(){',
'  currentParameterLength = (checklist[currentArray].toString() + this.value).length;',
'  if(currentParameterLength > maxParameterLength - 1) {',
'    if(currentArray < checklist.length - 1) {',
'      currentArray++;',
'    } else {',
'      tooManyCheckboxes = true;',
'    }',
'  }',
'  if(!tooManyCheckboxes) checklist[currentArray].push(this.value);',
'  numberOfCheckboxes++;',
'});',
'',
'if(!tooManyCheckboxes) {',
'  apex.server.process(',
'    (headerIsCheckedByUser ? ''asp_header_checked'' : ''asp_header_not_checked''),',
'     {x01: checklist[1].toString(),',
'      x02: checklist[2].toString(),',
'      x03: checklist[3].toString(),',
'      x04: checklist[4].toString(),',
'      x05: checklist[5].toString(),',
'      x06: checklist[6].toString(),',
'      x07: checklist[7].toString(),',
'      x08: checklist[8].toString(),',
'      x09: checklist[9].toString(),',
'      x10: checklist[10].toString()',
'      },',
'      {',
'        success: function (pData) {',
'          checkboxHeader.checked = !!headerIsCheckedByUser;',
'          $affectedCheckboxes.prop(''checked'', headerIsCheckedByUser);',
'          displayNumChecked(pData);',
'          spinner.remove();',
'      },',
'        dataType: "text"',
'      }',
'  );',
'} else { // tooManyEntries',
'  spinner.remove();',
unistr('  alert(''Die Anzahl der Checkboxen ('' + numberOfCheckboxes + '') ist zu gro\00DF f\00FCr die gemeinsame Ausf\00FChrung: \005CnBitte verringern Sie die Anzahl der Zeilen pro Reportseite \005Cn("Aktionen > Format > Zeilen pro Seite") \005Cnoder ordnen Sie das gesamte Ausbaugeb')
||unistr('iet per Schaltfl\00E4che zu.'');'),
'}',
''))
,p_da_action_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('1. Alle dargestellten(!) Checkboxen, die entsprechend der Header-Checkbox umgestellt werden m\00FCssen, in die n\00E4chste freie "checklist"-Liste eintragen (aber nicht anhaken!). Die Arrays werden beginnend mit index 1 aufgef\00FCllt (bis max. index = 10).'),
'2. "checklist"-Listen an den Server schicken. ',
unistr('3. Server tr\00E4gt die Checkboxen in die Collection ein.'),
'4. Beim success-Callback: Alle Checkboxen aus den checklist-Listen im Report setzen (ohne den Click-Event zu triggern, sonst Feedback-Schleife)',
unistr('   Prinzipiell k\00F6nnte man direkt danach die Seite sogar neu laden, da die Checkboxen zu diesem Zeitpunkt ja bereits persistiert sind')))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(214606145734121226)
,p_event_id=>wwv_flow_imp.id(211585835425690578)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(211588249965690602)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(205995220267428180)
,p_da_action_comment=>'Das Monitoring der Checkboxen aktualisieren'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(211585975166690580)
,p_name=>'Checkbox Adresszeile'
,p_event_sequence=>140
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'input.checkbox--ir'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#adressenIR'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('Setzt oder entfernt das Auswahl-H\00E4kchen in jeder Adressen-Reportzeile, wenn der Benutzer deren Checkbox anklickt.')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(211586100050690581)
,p_event_id=>wwv_flow_imp.id(211585975166690580)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let checkbox = this.triggeringElement;',
'let hausLfdNr = checkbox.value;',
'let checkboxIsCheckedByUser = !!checkbox.checked;',
'checkbox.checked = !checkboxIsCheckedByUser;',
'',
'apex.server.process(',
'   ''asp_set_checkbox'',',
'    {x01: checkboxIsCheckedByUser ? 1:0,',
'     x02: hausLfdNr',
'    },',
'    {',
'      success: function (pData) {',
'        $(''#adressenIR input.checkbox--ir[value='' + hausLfdNr + '']'').prop(''checked'', !!checkboxIsCheckedByUser);',
'        displayNumChecked(pData);',
'    },',
'    dataType: "text"',
'    }',
');',
''))
,p_da_action_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Die \00C4nderung der Checkbox-Auswahl wird zun\00E4chst verhindert: Der tats\00E4chliche Wert wird erst vom AJAX-Callbvakc best\00E4tigt und visualisiert. In der success-function wird zudem der WErt jeder checkbox aktualisiert, deren Zeile dieselbe HAUS_LFD_NR besit')
||unistr('zt (denn die HAUS_LFD_NR im Report ist nicht eindeutig. Daher muss jede weitere Zeile, die dasselbe Haus repr\00E4sentiert, ebenfalls umgestellt werden.'),
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(214605975342121225)
,p_event_id=>wwv_flow_imp.id(211585975166690580)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(211588249965690602)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(205995220267428180)
,p_da_action_comment=>'Den Monitoring-Report der Checkboxen aktualisieren'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(216065197166669226)
,p_name=>'Filter-Item hervorheben'
,p_event_sequence=>150
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_da_event_comment=>'Hebt das jeweils aktive Suchfeld optisch hervor'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220171799976178277)
,p_event_id=>wwv_flow_imp.id(216065197166669226)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let filter = apex.item(''P4_FILTER'').getValue();',
'var filterItem;',
'switch(filter) {',
'  case ''1'': filterItem = ''#P4_SEARCH_GEBIET''; break;',
'  case ''2'': filterItem = ''#P4_SEARCH_TYP''   ; break;',
'  case ''4'': filterItem = ''#P4_SEARCH_ALL''   ; break;',
'}',
'$(filterItem).addClass(''selected'');'))
,p_da_action_comment=>'Dem aktiven Suchfeld die CSS-Klasse "selected" zuweisen'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220172220758178281)
,p_name=>'P4_SEARCH_ALL [Enter]'
,p_event_sequence=>160
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_SEARCH_ALL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('Sorgt daf\00FCr, dass Benutzer durch Dr\00FCcken der Enter- (Return)-Taste im Feld "Adresse" die Suche ausl\00F6sen. Dieses Verhalten darf nicht deklarativ eingestellt werden, da wir den REQUEST-Wert auswerten m\00FCssen (dieser ist bei der deklarativen Variante abe')
||'r leer)'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220172273542178282)
,p_event_id=>wwv_flow_imp.id(220172220758178281)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'P4_SEARCH_ALL'
,p_attribute_02=>'Y'
,p_da_action_comment=>unistr('Wichtig ist hier die \00DCbergabe des REQUESTs, der dem Namen des Buttons mit der gleichen Funktion entspricht (Absenden des Suchstrings)')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220172530799178284)
,p_name=>'BTN_KOMPLETTES_GEBIET_ZUORDNEN'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(211459207858287014)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('Fragt den Benutzer, ob er tats\00E4chlich das komplette Gebiet/Typ zuordnen m\00F6chte, und submittet anschlie\00DFend den Request')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220172605502178285)
,p_event_id=>wwv_flow_imp.id(220172530799178284)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>unistr('&P4_FILTER_NAME. vollst\00E4ndig dem Vermarktungscluster "&P4_VC_NAME." zuordnen?')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220172720327178286)
,p_event_id=>wwv_flow_imp.id(220172530799178284)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'BTN_KOMPLETTES_GEBIET_ZUORDNEN'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220172817152178287)
,p_name=>'BTN_AUSWAHL_LOESCHEN'
,p_event_sequence=>180
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(216064416849669218)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('Fragt den Benutzer, ob er tats\00E4chlich die Adressenauswahl zur\00FCcksetzen m\00F6chte, und submittet anschlie\00DFend den Request')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220172915998178288)
,p_event_id=>wwv_flow_imp.id(220172817152178287)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Adressenauswahl komplett verwerfen?'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220173029220178289)
,p_event_id=>wwv_flow_imp.id(220172817152178287)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'BTN_AUSWAHL_LOESCHEN'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220173645180178295)
,p_name=>'Spinner ausblenden (nach IR Refresh)'
,p_event_sequence=>190
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(209052772198315201)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220173699518178296)
,p_event_id=>wwv_flow_imp.id(220173645180178295)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'spinner.remove();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220173831765178297)
,p_name=>'Spinner einblenden (vor IR Refresh)'
,p_event_sequence=>200
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(209052772198315201)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexbeforerefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220173866885178298)
,p_event_id=>wwv_flow_imp.id(220173831765178297)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'spinner = apex.util.showSpinner();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220174368509178303)
,p_name=>'P4_SEARCH_GEBIET Change'
,p_event_sequence=>210
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_SEARCH_GEBIET'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('Reagiert auf eine \00C4nderung des Wertes in der Selectliste')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220174498279178304)
,p_event_id=>wwv_flow_imp.id(220174368509178303)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'P4_SEARCH_GEBIET'
,p_attribute_02=>'Y'
,p_da_action_comment=>'Statt eines direkten SUBMIT: Zweck dieser DA ist es, den Page Spinner anzugezeigen ("Show Processing")'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(220174644404178305)
,p_name=>'P4_SEARCH_TYP Change'
,p_event_sequence=>220
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P4_SEARCH_TYP'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('Reagiert auf eine \00C4nderung des Wertes in der Selectliste')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(220174749735178306)
,p_event_id=>wwv_flow_imp.id(220174644404178305)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'P4_SEARCH_TYP'
,p_attribute_02=>'Y'
,p_da_action_comment=>'Statt eines direkten SUBMIT: Zweck dieser DA ist es, den Page Spinner anzugezeigen ("Show Processing")'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216064905177669223)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Filter setzen'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_FILTER := CASE :REQUEST ',
'                   WHEN ''P4_SEARCH_GEBIET'' THEN 1',
'                   WHEN ''P4_SEARCH_TYP''    THEN 2',
'                   WHEN ''P4_SEARCH_ALL''    THEN 4                   ',
'                   WHEN ''BTN_SEARCH''       THEN 4',
'                   ELSE :P4_FILTER',
'              END;',
'CASE :P4_FILTER',
'    WHEN 0 THEN',
'        :P4_SEARCH_GEBIET := NULL;',
'        :P4_SEARCH_TYP    := NULL;',
'        :P4_SEARCH_ALL    := NULL;',
'    WHEN 1 THEN',
'        :P4_SEARCH_TYP    := NULL;',
'        :P4_SEARCH_ALL    := NULL;',
'    WHEN 2 THEN',
'        :P4_SEARCH_GEBIET := NULL;',
'        :P4_SEARCH_ALL    := NULL;',
'    WHEN 4 THEN',
'        :P4_SEARCH_GEBIET := NULL;',
'        :P4_SEARCH_TYP    := NULL;',
'    ELSE',
'        NULL;',
'END CASE;',
'',
':P4_FILTER_NAME := CASE :P4_FILTER',
'                     WHEN 0 THEN ''''',
'                     WHEN 1 THEN ''Dieses Ausbaugebiet''',
'                     WHEN 2 THEN ''Diesen Ausbaugebiet-Typ''',
'                     WHEN 4 THEN ''Diesen Adressbereich'' -- nett, kommt aber derzeit nicht zum Einsatz',
'                     ELSE NULL',
'                   END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>51149044087586547
,p_process_comment=>unistr('Setzt die Werte f\00FCr die Items P4_FILTER und P4_FILTER_NAME und l\00F6scht diejenigen Eingabefelder, die nichts mit der aktuellen Suche zu tun haben, damit nicht (wie fr\00FCher) v\00F6llig irrelevante Werte oberhalb des Reports zu sehen sind')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(214959609871211483)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_AUSWAHL_BEARBEITEN'
,p_process_sql_clob=>':P4_AUSWAHL_BEARBEITEN := 1;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(214959356412211480)
,p_internal_uid=>50043748781128807
,p_process_comment=>unistr('Stellt den Report auf die Darstellung der ausgew\00E4hlten Adressen um. Die drei Suchfelder sind w\00E4hrenddessen ausgeblendet.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(214959754913211484)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_AUSWAHL_BEARBEITEN_BEENDEN'
,p_process_sql_clob=>':P4_AUSWAHL_BEARBEITEN := NULL;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(214959560548211482)
,p_internal_uid=>50043893823128808
,p_process_comment=>unistr('Stellt den Report wieder auf die normale Suchfunktion zur\00FCck.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216060816468669182)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_KOMPLETTES_GEBIET_ZUORDNEN (Gebiet)'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_ANZAHL_OBJEKTE := PCK_VERMARKTUNGSCLUSTER.komplettes_gebiet_zuordnen(',
'  pin_vc_lfd_nr => :P4_VC_ID',
' ,piv_gebiet    => :P4_SEARCH_GEBIET',
' ,piv_typ       => :P4_SEARCH_TYP',
');',
'PCK_VERMARKTUNGSCLUSTER.p_reset_alle_collections(piv_collection_name_like => ''P4%'');',
''))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Das Gebiet konnte nicht zugeordnet werden: #SQLERRM_TEXT#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(211459207858287014)
,p_process_when=>'P4_SEARCH_GEBIET'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_process_success_message=>'Das komplette Ausbaugebiet wurde dem Vermarktungscluster zugeordnet.'
,p_internal_uid=>51144955378586506
,p_process_comment=>'Wenn die Konstante MODUS auf ''ZAEHLEN'' gestellt wird, dann passiert keine Zuordnung, sondern die voraussichtliche Anzahl der zuordenbaren Adressen wird P4_ANZAHL_OBJEKTE abgelegt.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(220172398818178283)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_KOMPLETTES_GEBIET_ZUORDNEN (Typ)'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_ANZAHL_OBJEKTE := PCK_VERMARKTUNGSCLUSTER.komplettes_gebiet_zuordnen(',
'  pin_vc_lfd_nr => :P4_VC_ID',
' ,piv_gebiet    => :P4_SEARCH_GEBIET',
' ,piv_typ       => :P4_SEARCH_TYP',
');',
'PCK_VERMARKTUNGSCLUSTER.p_reset_alle_collections(piv_collection_name_like => ''P4%'');',
''))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Der Gebietstyp konnte nicht zugeordnet werden: #SQLERRM_TEXT#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(211459207858287014)
,p_process_when=>'P4_SEARCH_TYP'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_process_success_message=>'Der komplette Ausbaugebiets-Typ wurde dem Vermarktungscluster zugeordnet.'
,p_internal_uid=>55256537728095607
,p_process_comment=>'Wenn die Konstante MODUS auf ''ZAEHLEN'' gestellt wird, dann passiert keine Zuordnung, sondern die voraussichtliche Anzahl der zuordenbaren Adressen wird P4_ANZAHL_OBJEKTE abgelegt.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216060746206669181)
,p_process_sequence=>60
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_ZUORDNUNGEN_SPEICHERN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- @deprecated: PCK_VERMARKTUNGSCLUSTER.auswahl_zuordnen(pin_vc_lfd_nr => :P4_VC_ID); -- neu wegen @ticket FTTH-1787:',
'PCK_VERMARKTUNGSCLUSTER.p_objektauswahl_vc_zuordnen(pin_vc_lfd_nr => :P4_VC_ID, piv_username => :APP_USER);',
'PCK_VERMARKTUNGSCLUSTER.p_reset_alle_collections(piv_collection_name_like => ''P4%'');'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'#SQLERRM_TEXT#'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(211462587270287019)
,p_process_success_message=>unistr('Die ausgew\00E4hlten Adressen wurden dem Vermarktungscluster zugeordnet.')
,p_internal_uid=>51144885116586505
,p_process_comment=>unistr('F\00FChrt die Zuordnung der get\00E4tigten Auswahl zum Vermarktungscluster durch und setzt danach alle Collections zur\00FCck. Im Anschluss werden \00FCblicherweise alle (jetzt zugeordneten) Adressen hellgr\00FCn hinterlegt dargestellt.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216064524783669219)
,p_process_sequence=>80
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BTN_AUSWAHL_LOESCHEN'
,p_process_sql_clob=>'APEX_COLLECTION.TRUNCATE_COLLECTION(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX);'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(216064416849669218)
,p_internal_uid=>51148663693586543
,p_process_comment=>unistr('Setzt die Checkbox-Collection zur\00FCck, so dass die gesamte Auswahl verworfen wird')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216064248862669216)
,p_process_sequence=>100
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'MON_LOESCHE_BESTEHENDE_ZUORDNUNGEN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DELETE VERMARKTUNGSCLUSTER_OBJEKT',
' WHERE VC_LFD_NR = (',
'     SELECT VC_LFD_NR',
'       FROM VERMARKTUNGSCLUSTER',
'      WHERE VC_LFD_NR = :P4_VC_ID ',
'        AND UPPER(BEZEICHNUNG) LIKE ''TEST%''',
'      );'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(216064119113669215)
,p_process_success_message=>unistr('Zuordnungen gel\00F6scht')
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_internal_uid=>51148387772586540
,p_process_comment=>unistr('Zerst\00F6rt alle bestehenden Zuordnungen zum Vermarktungscluster! Dieser Prozess ist nur f\00FCr die Entwicklung erlaubt. Der Vermarktungscluster muss zudem mit dem String "Test" beginnen.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209055054499315223)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RESET'
,p_process_sql_clob=>'APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX);'
,p_process_clob_language=>'PLSQL'
,p_process_when=>'RESET'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>44139193409232547
,p_process_comment=>unistr('Wenn vom Report auf Seite 1 zu dieser Seite gesprungen wurde, wobei der REQUEST = RESET zu setzen ist, dann wird die Collection geleert, die die Auswahl der H\00E4kchen speichert')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(216060378891669178)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RESET_ALLE_COLLECTIONS'
,p_process_sql_clob=>'PCK_VERMARKTUNGSCLUSTER.p_reset_alle_collections(piv_collection_name_like => ''P4%'');'
,p_process_clob_language=>'PLSQL'
,p_process_when=>'RESET_ALLE_COLLECTIONS'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_required_patch=>wwv_flow_imp.id(205995220267428180)
,p_internal_uid=>51144517801586502
,p_process_comment=>unistr('L\00F6scht s\00E4mtliche Collections P4_... und legt danach die Checkbox-Collection leer an, wenn der REQUEST = RESET_ALLE_COLLECTIONS lautet (dies erfolgt nach dem erfolgreichen Zuordnen von Objekten durch Klick auf einen den "Zuordnen"-Buttons)')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(211588053009690600)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DO_SEARCH, NUM_CHECKED'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P4_DO_SEARCH := CASE WHEN :P4_SEARCH_GEBIET IS NOT NULL OR :P4_SEARCH_TYP IS NOT NULL OR :P4_SEARCH_ALL IS NOT NULL THEN 1 ELSE 0 END;',
':P4_NUM_CHECKED := PCK_VERMARKTUNGSCLUSTER.fn_count_checked_members(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX);',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>46672191919607924
,p_process_comment=>unistr('Setzt das Item P4_DO_SEARCH (welches bestimmt, ob der Adressen-Report aktiviert wird) und ermittelt f\00FCr dessen \00DCberschrift, wieviele Checkboxen im aktuell angezeigten Report angehakt sind (suche: displayNumChecked).')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(220171964066178279)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'asp_header_checked'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.asp_header_checked (',
'  piv_collection_name => PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX',
' ,pin_keys_1          => apex_application.g_x01',
' ,pin_keys_2          => apex_application.g_x02',
' ,pin_keys_3          => apex_application.g_x03',
' ,pin_keys_4          => apex_application.g_x04',
' ,pin_keys_5          => apex_application.g_x05',
' ,pin_keys_6          => apex_application.g_x06',
' ,pin_keys_7          => apex_application.g_x07',
' ,pin_keys_8          => apex_application.g_x08',
' ,pin_keys_9          => apex_application.g_x09',
' ,pin_keys_10         => apex_application.g_x10',
');',
'htp.p(PCK_VERMARKTUNGSCLUSTER.fn_count_checked_members(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX));',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>55256102976095603
,p_process_comment=>unistr('Ruft die Datenbankprozedur auf, die das H\00E4kchen aller aufgelisteten Checkboxen setzt, und liefert die Anzahl der anschlie\00DFend angehakten Checkboxen zur\00FCck (da sowieso irgendetwas zur\00FCckgeliefert werden muss, wird diese Zahl anstatt eines Leerstrings ')
||unistr('dazu verwendet, die Gr\00F6\00DFe der Auswahl in der Titelzeile der Region zu aktualisieren). Der wichtigeste Unterschied zu asp_set_checkbox ist, dass s\00E4mtliche Arrays apex_application.g_x01..g_x10 an die Datenbankprozedur \00FCbergeben werden, damit eine m\00F6gli')
||unistr('chst gro\00DFe Anzahl an H\00E4kchen gleichzeitig gesetzt werden kann (APEX: maximal 32767 Zeichen pro Parameter, mal 10, verteilt auf die ausgew\00E4hlten HAUS_LFD_NRn + jeweils ein Komma ergibt ca. 40.000 Eintr\00E4ge)')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(220172088518178280)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'asp_header_not_checked'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.asp_header_not_checked ( ',
'  piv_collection_name => PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX',
' ,pin_keys_1          => apex_application.g_x01',
' ,pin_keys_2          => apex_application.g_x02',
' ,pin_keys_3          => apex_application.g_x03',
' ,pin_keys_4          => apex_application.g_x04',
' ,pin_keys_5          => apex_application.g_x05',
' ,pin_keys_6          => apex_application.g_x06',
' ,pin_keys_7          => apex_application.g_x07',
' ,pin_keys_8          => apex_application.g_x08',
' ,pin_keys_9          => apex_application.g_x09',
' ,pin_keys_10         => apex_application.g_x10',
');',
'htp.p(PCK_VERMARKTUNGSCLUSTER.fn_count_checked_members(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX));',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>55256227428095604
,p_process_comment=>unistr('Ruft die Datenbankprozedur auf, die das H\00E4kchen aller aufgelisteten Checkboxen entfernt, und liefert die Anzahl der anschlie\00DFend noch angehakten Checkboxen zur\00FCck (da sowieso irgendetwas zur\00FCckgeliefert werden muss, wird diese Zahl anstatt eines Leer')
||unistr('strings dazu verwendet, die Gr\00F6\00DFe der Auswahl in der Titelzeile der Region zu aktualisieren). Der wichtigeste Unterschied zu asp_set_checkbox ist, dass s\00E4mtliche Arrays apex_application.g_x01..g_x10 an die Datenbankprozedur \00FCbergeben werden, damit ei')
||unistr('ne m\00F6glichst gro\00DFe Anzahl an H\00E4kchen gleichzeitig gesetzt werden kann  (APEX: maximal 32767 Zeichen pro Parameter)')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(211586260779690582)
,p_process_sequence=>50
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'asp_set_checkbox'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.asp_set_checkbox(',
'  piv_collection_name => PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX',
' ,pin_checked         => apex_application.g_x01',
' ,pin_key             => apex_application.g_x02',
');',
'htp.p(PCK_VERMARKTUNGSCLUSTER.fn_count_checked_members(PCK_VERMARKTUNGSCLUSTER.COLLECTION_P4_CHECKBOX));'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>46670399689607906
,p_process_comment=>unistr('Ruft die Datenbankprozedur auf, die das H\00E4kchen der Checkbox ein- oder ausschaltet, und liefert die Anzahl der aktuell angehakten Checkboxen zur\00FCck (da sowieso irgendetwas zur\00FCckgeliefert werden muss, wird diese Zahl anstatt eines Leerstrings dazu ve')
||unistr('rwendet, die Gr\00F6\00DFe der Auswahl in der Titelzeile der Region zu aktualisieren)')
);
wwv_flow_imp.component_end;
end;
/
