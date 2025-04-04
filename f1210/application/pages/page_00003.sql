prompt --application/pages/page_00003
begin
--   Manifest
--     PAGE: 00003
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
 p_id=>3
,p_name=>'Vermarktungscluster'
,p_alias=>'VERMARKTUNGSCLUSTER-BEARBEITEN'
,p_page_mode=>'MODAL'
,p_step_title=>'Vermarktungscluster'
,p_warn_on_unsaved_changes=>'N'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#P3_BEZEICHNUNG {',
'  font-weight:bold;',
'}',
'::placeholder {',
'  color:#CCC!important;',
'}',
'button.a-Button.a-DatePicker--clear {',
'  display:none;',
'}',
'label#P3_BEZEICHNUNG_LABEL {',
'    font-size:.86em;',
'}'))
,p_step_template=>wwv_flow_imp.id(236512409267961936)
,p_page_template_options=>'#DEFAULT#:t-PageBody--noContentPadding'
,p_dialog_width=>'1000'
,p_protection_level=>'C'
,p_page_comment=>unistr('@ticket FTTH-2547: Dieser Dialog ersetzt die Bearbeiten-Funktion im Interactive Grid. Diese hatte mit Umstellung auf APEX 23 einen (im Ticket dargestellten) Bug, der nicht durch andere Ma\00DFnahmen behebbar war. Darum wird nun anstelle des inplace-Editi')
||unistr('ngs diese Seite ge\00F6ffnet, was weitere Vorteile mit sich bringt (bessere Validierung und Informationsdarstellung mit Hinweistexten f\00FCr den Nutzer)')
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197386640623795686)
,p_plug_name=>'Fomularfelder'
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_query_type=>'TABLE'
,p_query_table=>'VERMARKTUNGSCLUSTER'
,p_include_rowid_column=>false
,p_is_editable=>false
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197389610806795716)
,p_plug_name=>'rechts'
,p_parent_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>120
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197389705198795717)
,p_plug_name=>'links'
,p_parent_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>110
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197389782330795718)
,p_plug_name=>'oben'
,p_parent_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_region_template_options=>'#DEFAULT#:margin-bottom-lg'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>100
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197389914090795719)
,p_plug_name=>'unten'
,p_parent_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>130
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(197388713061795707)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--noBorder:t-Region--scrollBody'
,p_region_attributes=>'style="padding: 0 22px"'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>40
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(197388534603795705)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(197388713061795707)
,p_button_name=>'BTN_INSERT_CLUSTER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Vermarktungscluster anlegen'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P3_VC_LFD_NR'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_icon_css_classes=>'fa-square-selected-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(197388589783795706)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(197388713061795707)
,p_button_name=>'BTN_UPDATE_CLUSTER'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\00C4nderungen speichern')
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P3_VC_LFD_NR'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-check'
,p_button_comment=>'@ticket FTTH-3169: Mandant wird gespeichert'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(197389998831795720)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(197388713061795707)
,p_button_name=>'BTN_CANCEL_EDIT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--gapRight'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'Abbrechen'
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-check-square'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(192182540925872625)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(197388713061795707)
,p_button_name=>'BTN_DELETE_CLUSTER'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_image_alt=>unistr('Cluster l\00F6schen ...')
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:14:&SESSION.::&DEBUG.::P14_VC_LFD_NR,P14_BEZEICHNUNG:&P3_VC_LFD_NR.,&P3_BEZEICHNUNG.'
,p_button_condition=>'P3_VC_LFD_NR'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-warning'
,p_button_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-2323',
'@ticket FTTH-2636'))
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(193800130150638991)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(197388713061795707)
,p_button_name=>'BTN_RESET_ZUM_TESTEN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--warning'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'RESET Status auf AreaPlanned'
,p_button_position=>'PREVIOUS'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_button_condition=>'1=0 AND UPPER(:APP_USER) IN (''KUEPHI'', ''WISAND'') AND :P3_VC_LFD_NR IS NOT NULL'
,p_button_condition2=>'PLSQL'
,p_button_condition_type=>'EXPRESSION'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(197388933257795709)
,p_branch_name=>'nach INSERT_CLUSTER'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(197388534603795705)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(197388995096795710)
,p_branch_name=>'nach UPDATE_CLUSTER'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(197388589783795706)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(201842577929948480)
,p_branch_name=>'nach DELETE_CLUSTER'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(192182540925872625)
,p_branch_sequence=>30
,p_branch_comment=>'@ticket FTTH-2636.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(193800542965638995)
,p_name=>'P3_WHOLEBUY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Wholebuy-Partner'
,p_source=>'WHOLEBUY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'WHOLEBUY-PARTNER'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT singular AS D,',
'       key      AS R',
'  FROM enum',
' WHERE domain = ''WHOLEBUY_PARTNER''',
'   AND kontext = ''FTTH''',
'   AND sprache = ''*''',
' ORDER BY pos'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'nein'
,p_cHeight=>1
,p_grid_label_column_span=>6
,p_read_only_when=>'P3_VC_LFD_NR'
,p_read_only_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_required_patch=>wwv_flow_imp.id(218771095566097073)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>unistr('@ticket FTTH-2901. Nach dem initialen Anlegen ist keine \00C4nderung mehr erlaubt (siehe Attribut "Read Only").')
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197386829148795688)
,p_name=>'P3_VC_LFD_NR'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_source=>'VC_LFD_NR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197386891665795689)
,p_name=>'P3_BEZEICHNUNG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(197389782330795718)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Bezeichnung'
,p_source=>'BEZEICHNUNG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197386986162795690)
,p_name=>'P3_DNSTTP_LFD_NR'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Technologie'
,p_source=>'DNSTTP_LFD_NR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select dnsttp_bez d , dnsttp_lfd_nr r',
'  from tab_dienst_typ',
' where dnsttp_lfd_nr in (70,51,71,89,90)'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Synonym: "Diensttyp".',
unistr('@ticket FTTH-3747: Technologie "HFC" (80) entf\00E4llt, daher zun\00E4chst Abkopplung von der Shared LOV "Technologie"')))
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387117444795691)
,p_name=>'P3_URL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(197389914090795719)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Landingpage PK'
,p_placeholder=>'https://'
,p_source=>'URL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Erlaubt sind URLs, die wie folgt beginnen:</p>',
'<ul>',
'    <li>https://www.netcologne.de/privatkunden</li>',
'    <li>https://www.netaachen.de/privatkunden</li>',
'    <li>https://www.netcologne.de/geschaeftskunden</li>',
'    <li>https://www.netaachen.de/geschaeftskunden</li>',
'</ul>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387257527795692)
,p_name=>'P3_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(197389782330795718)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Status'
,p_source=>'STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT disp_val, ret_val FROM core.v_lov_ausbaustatus WHERE ret_val IN (',
'  SELECT COLUMN_VALUE FROM TABLE(APEX_STRING.SPLIT(PCK_VERMARKTUNGSCLUSTER.fv_vc_folgestatus(:P3_STATUS), '','')))'))
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--radioButtonGroup'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '8',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387286198795693)
,p_name=>'P3_AUSBAU_PLAN_TERMIN'
,p_source_data_type=>'DATE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(197389610806795716)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Ausbau Plantermin'
,p_source=>'AUSBAU_PLAN_TERMIN'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_grid_label_column_span=>4
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'SHOW-WEEK:MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'HIDDEN',
  'display_as', 'INLINE',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387454209795694)
,p_name=>'P3_AKTIV'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Aktiv'
,p_source=>'AKTIV'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'JA | NEIN'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''ja'' AS D, 1 AS R FROM DUAL UNION ALL',
'SELECT ''nein'', 0 FROM DUAL',
' ORDER BY R DESC'))
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--radioButtonGroup'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387548734795695)
,p_name=>'P3_MINDESTBANDBREITE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Mindestbandbreite'
,p_source=>'MINDESTBANDBREITE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BANDBREITE (MINDESTBANDBREITE)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT BANDBREITE || '' Mbit/s'' AS D, BANDBREITE AS R',
'FROM',
'(SELECT 50 AS BANDBREITE FROM DUAL UNION ALL',
'SELECT 100 FROM DUAL UNION ALL',
'SELECT 250 FROM DUAL UNION ALL',
'SELECT 500 FROM DUAL UNION ALL',
'SELECT 1000 FROM DUAL',
')',
'ORDER BY BANDBREITE'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387594464795696)
,p_name=>'P3_ZIELBANDBREITE_GEPLANT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Zielbandbreite geplant'
,p_source=>'ZIELBANDBREITE_GEPLANT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'BANDBREITE (ZIELBANDBREITE_GEPLANT)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT BANDBREITE || '' Mbit/s'' AS D, BANDBREITE AS R',
'FROM',
'(',
'SELECT 500 AS BANDBREITE FROM DUAL UNION ALL',
'SELECT 1000 FROM DUAL',
')',
'ORDER BY BANDBREITE'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387737797795697)
,p_name=>'P3_KOSTEN_HAUSANSCHLUSS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Kosten Hausanschluss'
,p_placeholder=>'0,00'
,p_post_element_text=>'<span style="margin-left:2em;">Euro</span>'
,p_source=>'KOSTEN_HAUSANSCHLUSS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>10
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'min_value', '0',
  'number_alignment', 'center',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387797908795698)
,p_name=>'P3_KUNDENAUFTRAG_ERFORDERLICH'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(197389705198795717)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Kundenauftrag erforderlich'
,p_source=>'KUNDENAUFTRAG_ERFORDERLICH'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'JA | NEIN'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ''ja'' AS D, 1 AS R FROM DUAL UNION ALL',
'SELECT ''nein'', 0 FROM DUAL',
' ORDER BY R DESC'))
,p_grid_label_column_span=>6
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--radioButtonGroup'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197387932513795699)
,p_name=>'P3_NETWISSEN_SEITE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(197389914090795719)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Netwissen Seite'
,p_placeholder=>'https://'
,p_source=>'NETWISSEN_SEITE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_cMaxlength=>4000
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Erlaubt sind URLs, die wie folgt beginnen:</p>',
'<ul>',
'    <li>https://netwelt.netcologne.intern</li>',
'    <li>https://netwelt.netaachen.intern</li>',
'</ul>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197388033203795700)
,p_name=>'P3_INSERTED'
,p_source_data_type=>'DATE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_source=>'INSERTED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197388098983795701)
,p_name=>'P3_UPDATED'
,p_source_data_type=>'DATE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_source=>'UPDATED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197388171366795702)
,p_name=>'P3_INSERTED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_source=>'INSERTED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197388304064795703)
,p_name=>'P3_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(197388430059795704)
,p_name=>'P3_URL_GK'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(197389914090795719)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_prompt=>'Landingpage GK'
,p_placeholder=>'https://'
,p_source=>'URL_GK'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>120
,p_cMaxlength=>255
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Erlaubt sind URLs, die wie folgt beginnen:</p>',
'<ul>',
'    <li>https://www.netcologne.de/geschaeftskunden</li>',
'    <li>https://www.netaachen.de/geschaeftskunden</li>',
'    <li>https://www.netcologne.de/privatkunden</li>',
'    <li>https://www.netaachen.de/privatkunden</li>',
'</ul>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(201842953982948483)
,p_name=>'P3_ANZAHL_OBJEKTE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_item_comment=>'Beim Aufruf des Dialogs wird ermittelt, wie viele Objekte diesem Vermarktungscluster zuorgeordnet sind.'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(215817929698035747)
,p_name=>'P3_MANDANT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(197389782330795718)
,p_item_source_plug_id=>wwv_flow_imp.id(197386640623795686)
,p_item_default=>'NC'
,p_prompt=>'Mandant'
,p_source=>'MANDANT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC2:NetCologne;NC,NetAachen;NA'
,p_field_template=>wwv_flow_imp.id(236619486048961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--radioButtonGroup'
,p_is_persistent=>'N'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '2',
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>unistr('@ticket FTTH-3169. Der Mandant wird f\00FCr neu zu erstellende Vermarktungscluster per Default auf "NC" gesetzt.')
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193798830401638978)
,p_validation_name=>'Bezeichnung'
,p_validation_sequence=>10
,p_validation=>'REGEXP_LIKE(NVL(:P3_BEZEICHNUNG, ''-''), ''^[A-Za-z0-9_-]*$'')'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Die Bezeichnung des Vermarktungsclusters enth\00E4lt ung\00FCltige Zeichen')
,p_associated_item=>wwv_flow_imp.id(197386891665795689)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390078029795721)
,p_validation_name=>'Status'
,p_validation_sequence=>20
,p_validation=>'P3_STATUS'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>unistr('Der Status muss ausgew\00E4hlt werden')
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390179960795722)
,p_validation_name=>'Aktiv'
,p_validation_sequence=>30
,p_validation=>'P3_AKTIV'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'"Aktiv": Ja oder Nein ?'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390307458795723)
,p_validation_name=>'Technologie'
,p_validation_sequence=>40
,p_validation=>'P3_DNSTTP_LFD_NR'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Bitte geben Sie die Technologie an'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390416391795724)
,p_validation_name=>'Mindestbandbreite'
,p_validation_sequence=>50
,p_validation=>'P3_MINDESTBANDBREITE'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Bitte geben Sie die Mindestbandbreite an'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390506184795725)
,p_validation_name=>'Zielbandbreite geplant'
,p_validation_sequence=>60
,p_validation=>'P3_ZIELBANDBREITE_GEPLANT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Bitte geben Sie die geplante Zielbandbreite an'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(215818099852035749)
,p_validation_name=>'Mandant'
,p_validation_sequence=>70
,p_validation=>'P3_MANDANT'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>unistr('Bitte w\00E4hlen Sie den Mandanten zu diesem Vermarktungscluster')
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(197390659516795726)
,p_validation_name=>'Kundenauftrag erforderlich'
,p_validation_sequence=>80
,p_validation=>'P3_KUNDENAUFTRAG_ERFORDERLICH'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'"Kundenauftrag erforderlich": Ja oder Nein ?'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193798701625638977)
,p_validation_name=>'Kosten Hausanschluss'
,p_validation_sequence=>90
,p_validation=>'NvL(:P3_KOSTEN_HAUSANSCHLUSS, -1) >= 0'
,p_validation2=>'SQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Bitte geben Sie g\00FCltige Hausanschlusskosten an')
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193798889283638979)
,p_validation_name=>'Ausbau Plantermin'
,p_validation_sequence=>100
,p_validation=>'P3_AUSBAU_PLAN_TERMIN'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>unistr('Bitte geben Sie einen g\00FCltigen Ausbau-Plantermin an')
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193799615524638986)
,p_validation_name=>'Landingpage PK'
,p_validation_sequence=>110
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_URL IS NOT NULL AND',
'PCK_ADRESSE.fb_is_valid_url(',
'    piv_string   => :P3_URL',
'  , piv_protocol => ''https''',
'  , piv_like     => ''%/privatkunden%,%/geschaeftskunden%'' -- 2023-09-27 neu',
'  , piv_domains  => ''www.netcologne.de,www.netaachen.de''',
')'))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Die URL der Landingpage f\00FCr Privatkunden muss eine g\00FCltige NetCologne-/NetAachen-Adresse sein')
,p_associated_item=>wwv_flow_imp.id(197387117444795691)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_validation_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'@ticket FTTH-2837',
unistr('@date /////@todo 2024-04-10: Aufruf von FUNCTION fb_is_valid_url \00FCberall verlagern nach PCK_ADRESSE.fb_is_valid_url und Erstere droppen')))
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193799758830638987)
,p_validation_name=>'Landingpage GK'
,p_validation_sequence=>120
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_URL_GK IS NOT NULL AND',
'PCK_ADRESSE.fb_is_valid_url(',
'    piv_string   => :P3_URL_GK',
'  , piv_protocol => ''https''',
'  , piv_like     => ''%/privatkunden%,%/geschaeftskunden%'' -- 2023-09-27 neu, @ticket FTTH-2837',
'  , piv_domains  => ''www.netcologne.de,www.netaachen.de''',
')'))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Die URL der Landingpage f\00FCr Gesch\00E4ftskunden muss eine g\00FCltige NetCologne-/NetAachen-Adresse sein')
,p_associated_item=>wwv_flow_imp.id(197388430059795704)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(193799769793638988)
,p_validation_name=>'Netwissen-Seite'
,p_validation_sequence=>130
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr(':P3_NETWISSEN_SEITE IS NOT NULL AND -- /// fb_is_valid_url sollte NOT NULL ebenfalls pr\00FCfen'),
'PCK_ADRESSE.fb_is_valid_url(',
'    piv_string   => :P3_NETWISSEN_SEITE',
'  , piv_protocol => ''https''',
'  , piv_domains  => ''netwelt.netcologne.intern,netwelt.netaachen.intern''',
')'))
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>unistr('Die URL der Netwissen-Seite muss eine g\00FCltige NetWelt-Adresse von NetCologne-/NetAachen sein')
,p_associated_item=>wwv_flow_imp.id(197387932513795699)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(193799048501638980)
,p_name=>unistr('CANCEL: Dialog schlie\00DFen')
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(197389998831795720)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(193799063331638981)
,p_event_id=>wwv_flow_imp.id(193799048501638980)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(193800276115638993)
,p_name=>'Fokus auf leeres Feld Bezeichnung'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_display_when_type=>'ITEM_IS_NULL'
,p_display_when_cond=>'P3_BEZEICHNUNG'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(193800402548638994)
,p_event_id=>wwv_flow_imp.id(193800276115638993)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_FOCUS'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_BEZEICHNUNG'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(178847373952168700)
,p_name=>'Auswahl "Wholebuy-Partner"'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_WHOLEBUY'
,p_condition_element=>'P3_WHOLEBUY'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>unistr('@ticket FTTH-3747: Wenn ein Wholebuy-Partner f\00FCr diesen Vermarktungscluster ausgew\00E4hlt wird, dann soll der Diensttyp einen bestimmten festen Wert bekommen, der nicht mehr durch den Benutzer \00E4nderbar ist.')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(178847717174168703)
,p_event_id=>wwv_flow_imp.id(178847373952168700)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>'nein (kein Wholebuy-Partner)'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_DNSTTP_LFD_NR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'NULL'
,p_client_condition_element=>'P3_WHOLEBUY'
,p_da_action_comment=>'@ticket FTTH-3747'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(178847473936168701)
,p_event_id=>wwv_flow_imp.id(178847373952168700)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_name=>'TCOM'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_DNSTTP_LFD_NR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'89'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P3_WHOLEBUY'
,p_client_condition_expression=>'TCOM'
,p_da_action_comment=>'Der Wholebuy-Partner lautet "Telekom": Dann ist der Diensttyp = 89 ("FTTH_BSA_L2" bzw. "FTTH BSA L2")'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(178848452478168710)
,p_event_id=>wwv_flow_imp.id(178847373952168700)
,p_event_result=>'FALSE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>unistr('\00C4nderung "Diensttyp" erm\00F6glichen')
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$(''#P3_DNSTTP_LFD_NR'').css(''pointer-events'', ''auto'');'
,p_da_action_comment=>unistr('Es kann nicht die Aktion "Enable" verwendet werden, weil das Disablen nicht \00FCber die Aktion "Disable" geschehen konnte - weil ansonsten kein Submit des Items stattfinden w\00FCrde')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(178847565140168702)
,p_event_id=>wwv_flow_imp.id(178847373952168700)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'Y'
,p_name=>'DG'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_DNSTTP_LFD_NR'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'90'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_client_condition_type=>'EQUALS'
,p_client_condition_element=>'P3_WHOLEBUY'
,p_client_condition_expression=>'DG'
,p_da_action_comment=>'Der Wholebuy-Partner lautet "Deutsche Glasfaser": Dann ist der Diensttyp = 90 ("FTTH_BSA_L2_DG" bzw. "FTTH BSA L2 DG")'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(178848354854168709)
,p_event_id=>wwv_flow_imp.id(178847373952168700)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>unistr('\00C4nderung "Diensttyp" verhindern')
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$(''#P3_DNSTTP_LFD_NR'').css(''pointer-events'', ''none'');'
,p_da_action_comment=>unistr('Es kann nicht die Aktion "Disable" verwendet werden, weil ansonsten kein Submit des Items stattfinden w\00FCrde')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(53776480104138125)
,p_name=>'Auswahl Wholebuy-Technologie'
,p_event_sequence=>50
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P3_DNSTTP_LFD_NR'
,p_condition_element=>'P3_DNSTTP_LFD_NR'
,p_triggering_condition_type=>'IN_LIST'
,p_triggering_expression=>'89, 90'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
,p_da_event_comment=>'@krakar @FTTH-4474: Erstellen einer Dynamic Action, bei der geschaut wird, ob es sich bei der Technologie um eine Wholebuy-Technologie handelt. Falls es sich um eine Wholebuy-Technologie handelt sollen die Hausanschluss-Kosten automatisch auf 0 geset'
||unistr('zt werden und nicht mehr ver\00E4nderbar sein')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53776500812138126)
,p_event_id=>wwv_flow_imp.id(53776480104138125)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_KOSTEN_HAUSANSCHLUSS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_02=>'0,00'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_da_action_comment=>unistr('@krakar @ticket FTTH-4474: Falls sich bei der Technologie um einen Wholebuy-Partner handelt, soll das Kostenfeld f\00FCr Hausanschluss auf 0 gesetzt sein')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53776769793138128)
,p_event_id=>wwv_flow_imp.id(53776480104138125)
,p_event_result=>'FALSE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_name=>unistr('\00C4nderung "Kosten Hausanschluss" erm\00F6glichen')
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_KOSTEN_HAUSANSCHLUSS'
,p_attribute_01=>'$(''#P3_KOSTEN_HAUSANSCHLUSS'').css(''pointer-events'', ''auto'');'
,p_da_action_comment=>unistr('@krakar @ticket FTTH-4474: Falls sich bei der Technologie nicht um einen Wholebuy-Partner handelt, soll das Kostenfeld f\00FCr Hausanschluss wieder ver\00E4nderbar sein ')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(53776635893138127)
,p_event_id=>wwv_flow_imp.id(53776480104138125)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_name=>unistr('\00C4nderung "Kosten Hausanschluss" verhindern')
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P3_KOSTEN_HAUSANSCHLUSS'
,p_attribute_01=>'$(''#P3_KOSTEN_HAUSANSCHLUSS'').css(''pointer-events'', ''none'');'
,p_da_action_comment=>unistr('@krakar @ticket FTTH-4474: Kostenfeld f\00FCr Hausanschluss wird auf nicht ver\00E4nderbar eingestellt, wenn es sich bei Technologie um einen Wholebuy-Partner handelt')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(197388790980795708)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INSERT_CLUSTER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P1_VC_LFD_NR_DISPLAY := PCK_VERMARKTUNGSCLUSTER.fn_merge_cluster(',
'          pin_vc_lfd_nr                  => NULL',
'        , piv_mandant                    => :P3_MANDANT',
'	, piv_bezeichnung                => :P3_BEZEICHNUNG',
'	, pid_ausbau_plan_termin         => :P3_AUSBAU_PLAN_TERMIN',
'	, pin_dnsttp_lfd_nr              => :P3_DNSTTP_LFD_NR',
'	, piv_url                        => :P3_URL',
'	, piv_url_gk                     => :P3_URL_GK -- 2023-07-12 @ticket FTTH-2190',
'	, piv_status                     => :P3_STATUS',
'	, piv_aktiv                      => :P3_AKTIV',
'	, pin_mindestbandbreite          => :P3_MINDESTBANDBREITE',
'	, pin_zielbandbreite_geplant     => :P3_ZIELBANDBREITE_GEPLANT',
'	, pin_kosten_hausanschluss       => REPLACE(:P3_KOSTEN_HAUSANSCHLUSS, ''.'') -- keine Tausender',
'	, pin_kundenauftrag_erforderlich => :P3_KUNDENAUFTRAG_ERFORDERLICH',
'	, piv_netwissen_seite            => :P3_NETWISSEN_SEITE',
'	, piv_wholebuy                   => :P3_WHOLEBUY',
');',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(197388534603795705)
,p_process_success_message=>'Vermarktungscluster "&P3_BEZEICHNUNG." wurde angelegt.'
,p_internal_uid=>32472929890713032
,p_process_comment=>unistr('@ticket FTTH-2901: Im Zuge des neuen WHOLEBUY-Parameters wurde im PCK_VERMARKTUNGSCLUSTER eine neue Routine zum Anlegen eines Vermarktungsclusters geschaffen (fn_merge_cluster). Die zur\00FCckgegebene VC_LFD_NR wird dem entsprechenden Hidden Item auf der')
||' Seite 1 zugewiesen.'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(197389061176795711)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'UPDATE_CLUSTER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P1_VC_LFD_NR_DISPLAY := PCK_VERMARKTUNGSCLUSTER.fn_merge_cluster(',
unistr('  -- f\00FChrt ggf. auch einen Webservice-Aufruf durch:'),
'      pin_vc_lfd_nr                  => :P3_VC_LFD_NR',
'    , piv_mandant                    => :P3_MANDANT',
'    , piv_bezeichnung                => :P3_BEZEICHNUNG',
'    , pid_ausbau_plan_termin         => :P3_AUSBAU_PLAN_TERMIN',
'    , pin_dnsttp_lfd_nr              => :P3_DNSTTP_LFD_NR',
'    , piv_url                        => :P3_URL',
'    , piv_url_gk                     => :P3_URL_GK -- 2023-07-12 @ticket FTTH-2190',
'    , piv_status                     => :P3_STATUS',
'    , piv_aktiv                      => :P3_AKTIV',
'    , pin_mindestbandbreite          => :P3_MINDESTBANDBREITE',
'    , pin_zielbandbreite_geplant     => :P3_ZIELBANDBREITE_GEPLANT',
'    , pin_kosten_hausanschluss       => REPLACE(:P3_KOSTEN_HAUSANSCHLUSS, ''.'') -- keine Tausender',
'    , pin_kundenauftrag_erforderlich => :P3_KUNDENAUFTRAG_ERFORDERLICH',
'    , piv_netwissen_seite            => :P3_NETWISSEN_SEITE',
'    , piv_wholebuy                   => :P3_WHOLEBUY',
');'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(197388589783795706)
,p_process_success_message=>unistr('\00C4nderungen am Vermarktungscluster "&P3_BEZEICHNUNG." wurden gespeichert.')
,p_internal_uid=>32473200086713035
,p_process_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('@ticket FTTH-2901: Im Zuge des neuen WHOLEBUY-Parameters wurde im PCK_VERMARKTUNGSCLUSTER eine neue Routine zum Aktualisieren eines Vermarktungsclusters geschaffen (fn_merge_cluster). Die zur\00FCckgegebene VC_LFD_NR wird dem entsprechenden Hidden Item a')
||'uf der Seite 1 zugewiesen.',
'@ticket FTTH-3169: Mandant wird gespeichert.'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(193800162754638992)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'RESET_ZUM_TESTEN'
,p_process_sql_clob=>'UPDATE VERMARKTUNGSCLUSTER SET STATUS = ''AREAPLANNED'' WHERE VC_LFD_NR = :P3_VC_LFD_NR;'
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(193800130150638991)
,p_internal_uid=>28884301664556316
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(201842542475948479)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_CLUSTER'
,p_process_sql_clob=>'PCK_VERMARKTUNGSCLUSTER_DML.p_delete(pin_vc_lfd_nr => :P3_VC_LFD_NR);'
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>unistr('Vermarktungscluster "&P3_BEZEICHNUNG." konnte nicht gel\00F6scht werden: #SQLERRM#')
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(192182540925872625)
,p_process_success_message=>unistr('Vermarktungscluster "&P3_BEZEICHNUNG." wurde gel\00F6scht')
,p_internal_uid=>36926681385865803
,p_process_comment=>'@ticket FTTH-2636'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(197386686006795687)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(197386640623795686)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Vermarktungscluster bearbeiten'
,p_attribute_03=>'P3_VC_LFD_NR'
,p_internal_uid=>32470824916713011
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(201843048191948484)
,p_process_sequence=>20
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Anzahl Objekte ermitteln'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(*) ',
'  INTO :P3_ANZAHL_OBJEKTE',
'  FROM VERMARKTUNGSCLUSTER_OBJEKT',
' WHERE vc_lfd_nr = :P3_VC_LFD_NR;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P3_VC_LFD_NR'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>36927187101865808
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(193801234300639002)
,p_process_sequence=>30
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'WHOLEBUY-Partner "nein" falls NULL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P3_WHOLEBUY := ''nein'';',
''))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P3_WHOLEBUY'
,p_process_when_type=>'ITEM_IS_NULL'
,p_required_patch=>wwv_flow_imp.id(218771095566097073)
,p_internal_uid=>28885373210556326
,p_process_comment=>'@ticket FTTH-2901. Der Wert "nein" wird nicht in der Tabelle gespeichert (siehe PCK_VERMARKTUNGSCLUSTER.fn_merge_cluster)'
);
wwv_flow_imp.component_end;
end;
/
