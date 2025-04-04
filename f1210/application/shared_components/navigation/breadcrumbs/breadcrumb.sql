prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(236499478762961929)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(203600086075222994)
,p_parent_id=>wwv_flow_imp.id(237809088061856004)
,p_short_name=>'Objekt zuordnen'
,p_link=>'f?p=&APP_ID.:6:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>6
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(211464232894287029)
,p_parent_id=>wwv_flow_imp.id(237809088061856004)
,p_short_name=>'Objekte hinzuf&#xFC;gen'
,p_link=>'f?p=&APP_ID.:4:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>4
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(236499608476961929)
,p_short_name=>'Vermarktungscluster'
,p_link=>'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(237809088061856004)
,p_parent_id=>wwv_flow_imp.id(236499608476961929)
,p_short_name=>'Objekte'
,p_link=>'f?p=&APP_ID.:5:&SESSION.::&DEBUG.:::'
,p_page_id=>5
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(238600473191167479)
,p_parent_id=>wwv_flow_imp.id(237809088061856004)
,p_short_name=>unistr('Objekte hinzuf\00FCgen')
,p_link=>'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::'
,p_page_id=>7
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(203782190617764143)
,p_option_sequence=>30
,p_short_name=>'Listenimport: Zuordnung von Objekten zu Vermarktungsclustern'
,p_link=>'f?p=&APP_ID.:11:&SESSION.::&DEBUG.:::'
,p_page_id=>11
);
wwv_flow_imp.component_end;
end;
/
