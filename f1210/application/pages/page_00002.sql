prompt --application/pages/page_00002
begin
--   Manifest
--     PAGE: 00002
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
 p_id=>2
,p_name=>'Vermarktungscluster - Historie'
,p_alias=>'VERMARKTUNGSCLUSTER-HISTORIE'
,p_page_mode=>'MODAL'
,p_step_title=>'Vermarktungscluster - Historie'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_width=>'1100'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236216575103552357)
,p_plug_name=>'Historie'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236555122295961954)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT   versions_startscn',
'       , versions_starttime',
'       , versions_endscn',
'       , versions_endtime',
'       , versions_xid',
'       , versions_operation',
'       , vc_lfd_nr',
'       , bezeichnung',
'       , dnsttp_lfd_nr',
'       , url',
'       , status',
'       , ausbau_plan_termin',
'       , aktiv',
'       , inserted',
'       , updated',
'       , inserted_by',
'       , updated_by',
'FROM vermarktungscluster VERSIONS BETWEEN SCN MINVALUE AND MAXVALUE',
'WHERE vc_lfd_nr = :P2_VC_LFD_NR',
'ORDER BY versions_starttime desc'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P2_VC_LFD_NR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'MILLIMETERS'
,p_prn_paper_size=>'A4'
,p_prn_width=>297
,p_prn_height=>210
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header=>'Historie'
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
,p_plug_comment=>unistr('///@kl\00E4ren: 2023-08-15 @wisand von @holger: Tabelle ge\00E4ndert von VERTRIEBSCLUSTER zu VERMARKTUNGSCLUSTER')
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(236216665895552358)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'BOEHOL'
,p_internal_uid=>9768071038450442
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236216721792552359)
,p_db_column_name=>'VERSIONS_STARTSCN'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Versions Startscn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236216890833552360)
,p_db_column_name=>'VERSIONS_STARTTIME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Versions Starttime'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236216896893552361)
,p_db_column_name=>'VERSIONS_ENDSCN'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Versions Endscn'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236217023181552362)
,p_db_column_name=>'VERSIONS_ENDTIME'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Versions Endtime'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236217139525552363)
,p_db_column_name=>'VERSIONS_XID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Versions Xid'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236217244066552364)
,p_db_column_name=>'VERSIONS_OPERATION'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Versions Operation'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236217389096552365)
,p_db_column_name=>'VC_LFD_NR'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Vc Lfd Nr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236217439353552366)
,p_db_column_name=>'BEZEICHNUNG'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Bezeichnung'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236710992131423917)
,p_db_column_name=>'DNSTTP_LFD_NR'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Dnsttp Lfd Nr'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711061794423918)
,p_db_column_name=>'URL'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Url'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711122332423919)
,p_db_column_name=>'STATUS'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Status'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711263394423920)
,p_db_column_name=>'AUSBAU_PLAN_TERMIN'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Ausbau Plan Termin'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711339497423921)
,p_db_column_name=>'AKTIV'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Aktiv'
,p_column_type=>'NUMBER'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711478334423922)
,p_db_column_name=>'INSERTED'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Inserted'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711532127423923)
,p_db_column_name=>'UPDATED'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Updated'
,p_column_type=>'DATE'
,p_column_alignment=>'CENTER'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711662680423924)
,p_db_column_name=>'INSERTED_BY'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Inserted By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(236711792315423925)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(236724378122436741)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'102758'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'VERSIONS_STARTTIME:VERSIONS_OPERATION:BEZEICHNUNG:DNSTTP_LFD_NR:URL:STATUS:AUSBAU_PLAN_TERMIN:AKTIV:INSERTED:UPDATED:INSERTED_BY:UPDATED_BY:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(236711930957423927)
,p_plug_name=>'P2_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236711860855423926)
,p_name=>'P2_VC_LFD_NR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(236711930957423927)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp.component_end;
end;
/
