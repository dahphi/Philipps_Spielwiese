prompt --application/shared_components/navigation/lists/desktop_navigation_menu
begin
--   Manifest
--     LIST: Desktop Navigation Menu
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
 p_id=>wwv_flow_imp.id(236499903583961930)
,p_name=>'Desktop Navigation Menu'
,p_list_status=>'PUBLIC'
,p_version_scn=>4070393028055
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(236656756152962007)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Vermarktungscluster und Objekte'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(203599173161222989)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Objekt zuordnen'
,p_list_item_link_target=>'f?p=&APP_ID.:6:&SESSION.::&DEBUG.:6:::'
,p_list_item_icon=>'fa-map-marker-o'
,p_list_item_disp_cond_type=>'ITEM_IS_NOT_NULL'
,p_list_item_disp_condition=>'P6_HAUS_LFD_NR'
,p_parent_list_item_id=>wwv_flow_imp.id(236656756152962007)
,p_security_scheme=>wwv_flow_imp.id(238022332535849873)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'6'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(236691718558978162)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'Karte'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:::'
,p_list_item_disp_cond_type=>'EXISTS'
,p_list_item_disp_condition=>'select 1 from dual where lower(:APP_USER) = ''boehol'''
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(236926572229712297)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Historie'
,p_list_item_link_target=>'f?p=&APP_ID.:8:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-history'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(81848360436968930)
,p_list_item_display_sequence=>60
,p_list_item_link_text=>'Vermarktungscluster Historie'
,p_list_item_link_target=>'f?p=&APP_ID.:13:&SESSION.::&DEBUG.::::'
,p_list_item_icon=>'fa-history'
,p_parent_list_item_id=>wwv_flow_imp.id(236926572229712297)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(203781290365764133)
,p_list_item_display_sequence=>50
,p_list_item_link_text=>'Listenimport'
,p_list_item_link_target=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.::P11_STEP:1:'
,p_list_item_icon=>'fa-file-csv-o'
,p_security_scheme=>wwv_flow_imp.id(238022332535849873)
,p_list_item_current_type=>'COLON_DELIMITED_PAGE_LIST'
,p_list_item_current_for_pages=>'11'
);
wwv_flow_imp.component_end;
end;
/
