prompt --application/shared_components/navigation/lists/wizard_listenimport
begin
--   Manifest
--     LIST: Wizard "Listenimport"
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(204014745118143260)
,p_name=>'Wizard "Listenimport"'
,p_list_status=>'PUBLIC'
,p_version_scn=>1
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(204014947934143261)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>unistr('Datei ausw\00E4hlen')
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.:STEP-1:&DEBUG.::P11_STEP:1:'
,p_list_item_current_type=>'EXPRESSION'
,p_list_item_current_for_pages=>':REQUEST IS NULL OR :REQUEST = ''STEP-1'''
,p_list_item_current_language=>'SQL'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(204015358542143261)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Spalte und Aktion festlegen'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.:STEP-2:&DEBUG.::P11_STEP:2:'
,p_list_item_current_type=>'EXPRESSION'
,p_list_item_current_for_pages=>':REQUEST = ''STEP-2'''
,p_list_item_current_language=>'SQL'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(204018866291202181)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>unistr('Geplante Vorg\00E4nge pr\00FCfen')
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.:STEP-3:&DEBUG.:RP:P11_STEP:3:'
,p_list_item_current_type=>'EXPRESSION'
,p_list_item_current_for_pages=>':REQUEST = ''STEP-3'''
,p_list_item_current_language=>'SQL'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(204019247708205394)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>unistr('Aktionen ausf\00FChren')
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.:STEP-4:&DEBUG.::P11_STEP:4:'
,p_list_item_current_type=>'EXPRESSION'
,p_list_item_current_for_pages=>':REQUEST = ''STEP-4'''
,p_list_item_current_language=>'SQL'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(204019528281207234)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Zusammenfassung'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.:STEP-5:&DEBUG.::P11_STEP:5:'
,p_list_item_current_type=>'EXPRESSION'
,p_list_item_current_for_pages=>':REQUEST = ''STEP-5'''
,p_list_item_current_language=>'SQL'
);
wwv_flow_imp.component_end;
end;
/
