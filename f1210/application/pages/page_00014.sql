prompt --application/pages/page_00014
begin
--   Manifest
--     PAGE: 00014
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
 p_id=>14
,p_name=>unistr('Cluster  l\00F6schen')
,p_alias=>unistr('CLUSTER-L\00D6SCHEN1')
,p_page_mode=>'MODAL'
,p_step_title=>unistr('Cluster  l\00F6schen')
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.t-Form-fieldContainer .apex-item-radio label {',
'    display: block; /* Jedes Label auf eine neue Zeile */',
'    width: 100%; /* Stellt sicher, dass die Labels sich an die Breite anpassen */',
'}',
' ',
'.t-Form-fieldContainer .apex-item-radio {',
unistr('    display: flex; /* Flexbox f\00FCr bessere Kontrolle */'),
'    flex-direction: column; /* Vertikale Anordnung der Radio-Buttons */',
'}',
' ',
'.apex-item-radio label {',
unistr('    white-space: nowrap; /* Verhindert Zeilenumbr\00FCche */'),
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_height=>'335'
,p_dialog_width=>'300'
,p_dialog_max_width=>'300'
,p_protection_level=>'C'
,p_page_comment=>unistr('@krakar @FTTH-2323 Erstellen einer Seite zum L\00F6schen eines Vermarktungsclusters')
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(75007967198373870)
,p_plug_name=>unistr('L\00F6schgrund ausw\00E4hlen')
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'VERMARKTUNGSCLUSTER'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(91295532811482668)
,p_plug_name=>'Hinweis Vermarktungscluster'
,p_parent_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--noBorder:t-Region--scrollBody:margin-top-lg:margin-bottom-none:margin-right-lg'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_display_column=>2
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div style="font-size: 16px; background-color:#FF6; padding: 1em;">',
'<p><strong>Hinweis:</strong> <br>',
'Das Vermarktungscluster <br>',
'<strong>&P14_BEZEICHNUNG.</strong> <br>',
unistr('wird gel\00F6scht. <br></p>'),
'</div>'))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(91295693752482669)
,p_plug_name=>'Radio Group'
,p_parent_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_region_template_options=>'#DEFAULT#:t-Region--hideHeader:t-Region--noBorder:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(75022225995373896)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236527070826961945)
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(37519392184344546)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(75022225995373896)
,p_button_name=>'BTN_CONFIRM'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Best\00E4tigen und Cluster l\00F6schen')
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-trash-o'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(53777453143138135)
,p_branch_name=>'Go to Page 1'
,p_branch_action=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(37519392184344546)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(75009714772373886)
,p_name=>'P14_VC_LFD_NR'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_item_source_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_source=>'VC_LFD_NR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(75010112914373894)
,p_name=>'P14_BEZEICHNUNG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_item_source_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_source=>'BEZEICHNUNG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91297299391482683)
,p_name=>'P14_ANZAHL_OBJEKTE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_item_source_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_source=>'BEZEICHNUNG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(91300589568482688)
,p_name=>'P14_LOESCHGRUND'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(91295693752482669)
,p_item_source_plug_id=>wwv_flow_imp.id(75007967198373870)
,p_prompt=>unistr('<strong>Bitte w\00E4hlen Sie einen Grund aus:</strong>')
,p_source=>'LOESCHGRUND'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_named_lov=>'LOESCHGRUENDE'
,p_lov=>'.'||wwv_flow_imp.id(37527876153353916)||'.'
,p_begin_on_new_line=>'N'
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--xlarge'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
,p_item_comment=>unistr('@krakar @FTTH-2323 Radiogroup zur Auswahl von zur Verf\00FCgung stehenden L\00F6schgr\00FCnden')
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(37524731181344574)
,p_name=>'BTN_CONFIRM'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(37519392184344546)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37525287655344575)
,p_event_id=>wwv_flow_imp.id(37524731181344574)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>unistr('Hinweis Verkn\00FCpfungen')
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Dem Cluster sind Objekte zugeordnet (&P14_ANZAHL_OBJEKTE.).</p>',
unistr('<p>Bitte fahren Sie nur dann mit dem L\00F6schen des Clusters fort, wenn auch diese Zuordnungen gel\00F6scht werden d\00FCrfen.</p>')))
,p_attribute_02=>' &P14_BEZEICHNUNG.'
,p_client_condition_type=>'GREATER_THAN'
,p_client_condition_element=>'P14_ANZAHL_OBJEKTE'
,p_client_condition_expression=>'0'
,p_da_action_comment=>'Dieser Hinweis erfolgt nur, falls dem Cluster Objekte zugeordnet sind.'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37525777965344575)
,p_event_id=>wwv_flow_imp.id(37524731181344574)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Sicherheitsabfrage'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>unistr('<p>Sind Sie sicher, dass dieser Vermarktungscluster tats\00E4chlich gel\00F6scht werden soll?</p>')
,p_attribute_02=>' &P14_BEZEICHNUNG.'
,p_da_action_comment=>unistr('Abschlie\00DFende Sicherheitsabfrage, ob der Cluster jetzt gel\00F6scht werden soll.')
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(37526241826344576)
,p_event_id=>wwv_flow_imp.id(37524731181344574)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'Submit Page'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'BTN_CONFIRM'
,p_attribute_02=>'Y'
,p_da_action_comment=>unistr('Zum L\00F6schen absenden')
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(37522484874344555)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'UPDATE_VC'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE VERMARKTUNGSCLUSTER',
'    SET loeschgrund = :P14_LOESCHGRUND',
'    WHERE vc_lfd_nr = :P14_VC_LFD_NR;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>unistr('Vermarktungscluster "&P14_BEZEICHNUNG." konnte nicht gel\00F6scht werden: #SQLERRM#')
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(37519392184344546)
,p_process_success_message=>unistr('Vermarktungscluster "&P14_BEZEICHNUNG." wurde gel\00F6scht')
,p_internal_uid=>37522484874344555
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(37524371239344574)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DELETE_CLUSTER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PCK_VERMARKTUNGSCLUSTER_DML.p_delete(pin_vc_lfd_nr => :P14_VC_LFD_NR);',
''))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>unistr('Vermarktungscluster "&P14_BEZEICHNUNG." konnte nicht gel\00F6scht werden: #SQLERRM#')
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(37519392184344546)
,p_process_success_message=>unistr('Vermarktungscluster "&P14_BEZEICHNUNG." wurde gel\00F6scht')
,p_internal_uid=>37524371239344574
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(37522050712344554)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(75007967198373870)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>unistr('Initialize form Cluster  l\00F6schen')
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>37522050712344554
);
wwv_flow_imp.component_end;
end;
/
