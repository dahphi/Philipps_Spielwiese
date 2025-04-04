prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'Objekt zuordnen'
,p_alias=>'OBJEKT-ZUORDNEN'
,p_step_title=>'Objekt zuordnen'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#ausgewaehltesObjekt dl>dt{font-size:80%}',
'#ausgewaehltesObjekt dl>dd{margin-left:0;font-size:115%;font-weight:bold;color:#666;margin-bottom:2em}',
'',
'#reportVMC table.a-IRR-table tbody tr:not(:first-child){cursor:default}',
'#reportVMC table.a-IRR-table tbody tr:not(:first-child):hover>td,',
'#reportVMC table.a-IRR-table tbody tr.selected',
'{',
'  background-color:#7fabd6;',
'  color:#FFF',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_required_role=>wwv_flow_imp.id(238022332535849873)
,p_protection_level=>'C'
,p_page_comment=>unistr('@WISAND @date 2023-03-30: Topmen\00FCeintrag P6 konditional (nur sichtbar, wenn P6_HAUS_LFD_NR nicht NULL ist).')
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197640685849354618)
,p_plug_name=>unistr('Zuk\00FCnftiger Vermarktungscluster: <strong style="margin-left:2em" id="auswahlVMC">(Ausw\00E4hlen durch Anklicken)</strong>')
,p_region_name=>'regionVMC'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_new_grid_row=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
,p_plug_comment=>unistr('In der \00DCberschrift wird unter der HTML-ID #auswahlVMC die Bezeichnung des ausgew\00E4hlten Vermarkungsclusters eingeblendet, sobald der Benutzer im darunterliegenden Report auf eine Zeile geklickt hat')
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197640881531354620)
,p_plug_name=>'Vermarktungscluster'
,p_region_name=>'reportVMC'
,p_parent_plug_id=>wwv_flow_imp.id(197640685849354618)
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select VC_LFD_NR,',
'       BEZEICHNUNG,',
'       DNSTTP_LFD_NR,',
'       URL,',
'       STATUS,',
'       AUSBAU_PLAN_TERMIN,',
'       AKTIV,',
'       MINDESTBANDBREITE,',
'       ZIELBANDBREITE_GEPLANT,',
'       KOSTEN_HAUSANSCHLUSS,',
'       KUNDENAUFTRAG_ERFORDERLICH,',
'       NETWISSEN_SEITE,',
'       INSERTED,',
'       UPDATED,',
'       INSERTED_BY,',
'       UPDATED_BY',
'  from VERMARKTUNGSCLUSTER',
'    -- der aktuelle Cluster soll nicht zum "Neu Zuordnen" erscheinen:',
' WHERE :P6_VMC_ALT IS NULL OR VC_LFD_NR <> :P6_VMC_ALT'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P6_VMC_ALT'
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
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(197640968694354621)
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
,p_internal_uid=>32725107604271945
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(197641081411354622)
,p_db_column_name=>'VC_LFD_NR'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'lfd. Nr.'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'CENTER'
,p_static_id=>'vcLfdNr'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(197641248161354623)
,p_db_column_name=>'BEZEICHNUNG'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Bezeichnung'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_allow_hide=>'N'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_static_id=>'vcBezeichnung'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(197641304168354624)
,p_db_column_name=>'DNSTTP_LFD_NR'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Dnsttp Lfd Nr'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(197641380346354625)
,p_db_column_name=>'URL'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'URL'
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
 p_id=>wwv_flow_imp.id(197641499042354626)
,p_db_column_name=>'STATUS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Status'
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
 p_id=>wwv_flow_imp.id(203608263465478377)
,p_db_column_name=>'AUSBAU_PLAN_TERMIN'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Ausbau Plantermin'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203608405990478378)
,p_db_column_name=>'AKTIV'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Aktiv'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203608544670478379)
,p_db_column_name=>'MINDESTBANDBREITE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Mindestbandbreite'
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
 p_id=>wwv_flow_imp.id(203608608093478380)
,p_db_column_name=>'ZIELBANDBREITE_GEPLANT'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Zielbandbreite geplant'
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
 p_id=>wwv_flow_imp.id(203608760386478381)
,p_db_column_name=>'KOSTEN_HAUSANSCHLUSS'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Kosten Hausanschluss'
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
 p_id=>wwv_flow_imp.id(203608814330478382)
,p_db_column_name=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Kundenauftrag erforderlich'
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
 p_id=>wwv_flow_imp.id(203608932089478383)
,p_db_column_name=>'NETWISSEN_SEITE'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Netwissen-Seite'
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
 p_id=>wwv_flow_imp.id(203609051015478384)
,p_db_column_name=>'INSERTED'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Inserted'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203609084981478385)
,p_db_column_name=>'UPDATED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Updated'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203609235699478386)
,p_db_column_name=>'INSERTED_BY'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Inserted By'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(203609345050478387)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Updated By'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(203618481190478747)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'387027'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_display_rows=>10
,p_report_columns=>'VC_LFD_NR:BEZEICHNUNG:STATUS:AUSBAU_PLAN_TERMIN:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203599711028222993)
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
 p_id=>wwv_flow_imp.id(203609383846478388)
,p_plug_name=>unistr('Ausgew\00E4hltes Objekt:')
,p_region_name=>'ausgewaehltesObjekt'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_plug_grid_column_span=>3
,p_plug_item_display_point=>'BELOW'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'htp.p(',
'  ''<dl>''',
'  || ''<dt>HAUS_LFD_NR</dt><dd>'' || :P6_HAUS_LFD_NR || ''</dd>''',
'  || ''<dt>Adresse</dt><dd>'' || REPLACE(:P6_ADRESSE, '','', ''<br/>'') || ''</dd>''',
'  || CASE WHEN :P6_VMC_BEZEICHNUNG_ALT IS NULL THEN ',
'     ''<dt>- kein Vermarktungscluster -</dt><dd></dd>''',
'     ELSE ''<dt>bisheriger Vermarktungscluster</dt><dd>'' || REPLACE(:P6_VMC_BEZEICHNUNG_ALT, '','', ''<br/>'') || ''</dd>''',
'     END',
'  || ''</dl>''',
');'))
,p_plug_source_type=>'NATIVE_PLSQL'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(203610345178478397)
,p_plug_name=>'Hidden'
,p_plug_display_sequence=>40
,p_plug_display_point=>'REGION_POSITION_07'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(209052322584315196)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_imp.id(203609383846478388)
,p_button_name=>'BTN_ZUORDNUNG_LOESCHEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('Zuordnung zum Vermarktungscluster l\00F6schen')
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P6_VMC_ALT'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-map-marker-slash-o'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203609514771478389)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(197640685849354618)
,p_button_name=>'BTN_VERMARKTUNGSCLUSTER_ZUORDNEN'
,p_button_static_id=>'btnVermarktungsclusterZuordnen'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>'Vermarktungscluster jetzt zuordnen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_icon_css_classes=>'fa-map-marker-check'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(203609573484478390)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(197640685849354618)
,p_button_name=>'BTN_ABBRECHEN'
,p_button_action=>'REDIRECT_APP'
,p_button_template_options=>'#DEFAULT#:t-Button--iconRight:t-Button--padLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>'Abbrechen'
,p_button_position=>'COPY'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=1200:100:&SESSION.::&DEBUG.::P0_HAUS_LFD_NR:&P6_HAUS_LFD_NR.'
,p_icon_css_classes=>'fa-remove'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(203610467919478399)
,p_branch_name=>'OBJEKT_ZUGEORDNET'
,p_branch_action=>'f?p=&P6_APP_ID_RETURN.:&P6_PAGE_ID_RETURN.:&SESSION.::&DEBUG.::P0_HAUS_LFD_NR:&P6_HAUS_LFD_NR.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(203609514771478389)
,p_branch_sequence=>10
,p_branch_condition_type=>'ITEM_IS_NOT_NULL'
,p_branch_condition=>'P6_APP_ID_RETURN'
,p_branch_comment=>unistr('Bringt den Benutzer wieder zur Objektinfo-App zur\00FCck, nachdem der Vermarktungscluster zugeordnet wurde (sofern diese Seite von einer anderen APP_ID aufgerufen wurde)')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(209052618646315199)
,p_branch_name=>unistr('ZUORDNUNG_GEL\00D6SCHT')
,p_branch_action=>'f?p=&P6_APP_ID_RETURN.:&P6_PAGE_ID_RETURN.:&SESSION.::&DEBUG.::P0_HAUS_LFD_NR:&P6_HAUS_LFD_NR.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(209052322584315196)
,p_branch_sequence=>20
,p_branch_condition_type=>'ITEM_IS_NOT_NULL'
,p_branch_condition=>'P6_APP_ID_RETURN'
,p_branch_comment=>unistr('Bringt den Benutzer wieder zur Objektinfo-App zur\00FCck, nachdem die Zuordnung des Vermarktungsclusters gel\00F6scht wurde (sofern diese Seite von einer anderen APP_ID aufgerufen wurde)')
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(203610619225478400)
,p_branch_name=>'ABBRECHEN'
,p_branch_action=>'f?p=&P6_APP_ID_RETURN.:&P6_PAGE_ID_RETURN.:&SESSION.::&DEBUG.::P0_HAUS_LFD_NR:&P6_HAUS_LFD_NR.'
,p_branch_point=>'BEFORE_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(203609573484478390)
,p_branch_sequence=>30
,p_branch_comment=>unistr('Bringt den Benutzer wieder zur Objektinfo-App zur\00FCck, ohne eine \00C4nderung vorzunehmen')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197640854873354619)
,p_name=>'P6_HAUS_LFD_NR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(203609383846478388)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203609752247478391)
,p_name=>'P6_APP_ID_RETURN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(203610345178478397)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Wird von der aufrufenden App gef\00FCllt: Applikationsnummer, zu der nach Abschluss der Aufgabe zur\00FCckgesprungen wird')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203609836963478392)
,p_name=>'P6_PAGE_ID_RETURN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(203610345178478397)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Wird von der aufrufenden App gef\00FCllt: Seitennummer, zu der nach Abschluss der Aufgabe zur\00FCckgesprungen wird')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(203610015561478394)
,p_name=>'P6_ADRESSE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(203609383846478388)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(209051373887315187)
,p_name=>'P6_VC_LFD_NR'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(203610345178478397)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_item_comment=>unistr('Speichert die VC_LFD_NR des Clusters, das der Benutzer im Interactive Report ausgew\00E4hlt hat (siehe Dynamic Action)')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(209051889509315192)
,p_name=>'P6_VMC_ALT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(203609383846478388)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Wird anhand der HAUS_LFD_NR gef\00FCllt: Wenn bereits eine Zuordnung existiert, wird deren VC_LFD_NR hier gespeichert (also nicht die ID der Zuordnung, sondern die des Clusters!)')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(209051968298315193)
,p_name=>'P6_VMC_BEZEICHNUNG_ALT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(203609383846478388)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>unistr('Wird anhand der HAUS_LFD_NR gef\00FCllt: Wenn bereits eine Zuordnung existiert, wird der Name des bisherigen Vermarktungsclusters hier angezeigt.')
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(209052683503315200)
,p_validation_name=>unistr('Vermarktungscluster wurde ausgew\00E4hlt')
,p_validation_sequence=>10
,p_validation=>'P6_VC_LFD_NR'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>unistr('Bitte w\00E4hlen Sie den Vermarktungscluster f\00FCr die Zuordnung aus')
,p_when_button_pressed=>wwv_flow_imp.id(203609514771478389)
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(203610116849478395)
,p_name=>unistr('Vermarktungscluster ausw\00E4hlen')
,p_event_sequence=>10
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'#reportVMC td.u-tC, #reportVMC td.u-tL, #reportVMC td.u-tR'
,p_bind_type=>'live'
,p_bind_delegate_to_selector=>'#regionVMC'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
,p_da_event_comment=>unistr('F\00FChrt die Markierung und die Speicherung des Vermarktungsclusters durch, das der Benutzer im Report ausw\00E4hlt')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(203610210206478396)
,p_event_id=>wwv_flow_imp.id(203610116849478395)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$tr = $(this.triggeringElement).parent(''tr'');',
'$tr.closest(''tbody'').find(''tr'').removeClass(''selected'');',
'$tr.addClass(''selected'');',
'let vcLfdNr = $tr.find(''td[headers="vcLfdNr"]'').text();',
'let vcBezeichnung = $tr.find(''td[headers="vcBezeichnung"]'').text();',
'$(''#auswahlVMC'').text(vcBezeichnung);',
'let $button = $(''#btnVermarktungsclusterZuordnen'');',
'$button.addClass(''t-Button--hot'');',
'$button.find(''span.fa'').addClass(''fa-map-marker-check fa-anim-flash''); // chi chi',
'',
'apex.item(''P6_VC_LFD_NR'').setValue(vcLfdNr);'))
,p_da_action_comment=>unistr('Markiert die ausgew\00E4hlte Zeile im Report, schaltet den Button auf Hot, f\00FCllt das Item P6_VC_LFD_NR mit dem ausgew\00E4hlten VMC #FX')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209051814704315191)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'VERMARKTUNGSCLUSTER_ZUORDNEN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_objekt_zuordnen(',
'   pin_haus_lfd_nr => :P6_HAUS_LFD_NR',
'  ,pin_vc_lfd_nr   => :P6_VC_LFD_NR',
'  ,pin_modus       => pck_vermarktungscluster.c_modus_alternativ',
');',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(203609514771478389)
,p_process_success_message=>'Objekt wurde dem Vermarktungscluster zugeordnet.'
,p_internal_uid=>44135953614232515
,p_process_comment=>unistr('F\00FChrt die Zuordnung des Vermarktungsclusters durch.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209052451098315197)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'BESTEHENDE_ZUORDNUNG_LOESCHEN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER.p_objekt_zuordnen(',
'   pin_haus_lfd_nr => :P6_HAUS_LFD_NR',
'  ,pin_vc_lfd_nr   => :P6_VC_LFD_NR',
'  ,pin_modus       => pck_vermarktungscluster.c_modus_aufheben',
');',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(209052322584315196)
,p_process_success_message=>unistr('Zuordnung zum Vermarktungscluster wurde gel\00F6scht')
,p_internal_uid=>44136590008232521
,p_process_comment=>unistr('L\00F6scht die bestehende Zuordnung zum Vermarktungscluster ersatzlos')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209052117341315194)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Bisherigen Vermarktungscluster ermitteln'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT MAX(VCO.VC_LFD_NR), MAX(VMC.BEZEICHNUNG)',
'  INTO :P6_VMC_ALT, :P6_VMC_BEZEICHNUNG_ALT',
'  FROM VERMARKTUNGSCLUSTER_OBJEKT VCO',
'  JOIN VERMARKTUNGSCLUSTER VMC ON (VMC.vc_LFD_NR = VCO.VC_LFD_NR)',
' WHERE VCO.HAUS_LFD_NR = :P6_HAUS_LFD_NR;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'OBJEKTINFO_VMCLUSTER_ZUORDNUNG'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>44136256251232518
,p_process_comment=>unistr('Prozess wird einmalig ausgef\00FChrt, wenn diese Seite aus der Objektinfo-App aufgerufen wurde.')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(209052172689315195)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Hausadresse ermitteln'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ADRESSE_KOMPL',
'  INTO :P6_ADRESSE',
'  FROM V_ADRESSEN',
' WHERE HAUS_LFD_NR = :P6_HAUS_LFD_NR;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'OBJEKTINFO_VMCLUSTER_ZUORDNUNG'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>44136311599232519
,p_process_comment=>unistr('Prozess wird einmalig ausgef\00FChrt, wenn diese Seite aus der Objektinfo-App aufgerufen wurde.')
);
wwv_flow_imp.component_end;
end;
/
