prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(172065917917053091)
,p_build_option_name=>'DA: IG Copy Hack'
,p_build_option_status=>'INCLUDE'
,p_version_scn=>4047703841395
,p_build_option_comment=>unistr('Erm\00F6glicht es auf Seiten mit einem Interactive Grid, den Inhalt einer markierten Zelle vollst\00E4ndig als Text in die Zwischenablage zu kopieren')
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(205995220267428180)
,p_build_option_name=>'Monitoring'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>4001199399114
,p_default_on_export=>'EXCLUDE'
,p_build_option_comment=>unistr('Nur in der Entwicklung einschalten, um auf einigen Seiten zus\00E4tzliche Meta-Informationen zu erhalten (intern verwendete Tabellen, APEX_COLLECTIONS, Hilfs-Items etc.)')
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(217573164052110420)
,p_build_option_name=>'Entwicklerdokumentation'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>1
,p_default_on_export=>'EXCLUDE'
,p_build_option_comment=>'Include: Auf Seiten, wo eine Doku-View existiert, wird diese angezeigt.'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(218771095566097073)
,p_build_option_name=>'@ticket FTTH-2901'
,p_build_option_status=>'INCLUDE'
,p_version_scn=>1
,p_build_option_comment=>unistr('Wholebuy-Attribut f\00FCr Vermarktungs-Cluster')
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(236648763045961999)
,p_build_option_name=>'Feature: About Page'
,p_build_option_status=>'INCLUDE'
,p_version_scn=>1
,p_feature_identifier=>'APPLICATION_ABOUT_PAGE'
,p_build_option_comment=>'About this application page.'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(237797642514829750)
,p_build_option_name=>'DISABLED'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>1
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(300353711591504239)
,p_build_option_name=>'@ticket FTTH-1787'
,p_build_option_status=>'INCLUDE'
,p_version_scn=>1
,p_build_option_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('Steuerung des Status\00FCbergangs eines VM-Clusters: Kann erst live gehen, wenn die Schnittstelle MarketingStatusUpdate existiert und PCK_VERMAKRTUNGSCLUSTER ordnungsgem\00E4\00DF deployed ist.'),
unistr('2023-05-25: PCK_POB_REST blockt das Versenden an die nicht existierende Schnittstelle, Buttons k\00F6nnen also angezeigt werden, aber @ticket FTTH-1972 wartet weiterhin')))
);
wwv_flow_imp.component_end;
end;
/
