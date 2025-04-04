prompt --application/plugin_settings
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(1462713617143491)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_BOSS'
,p_version_scn=>4106711094741
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(64113890260370342)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SELECT_MANY'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_values_as', 'separated')).to_clob
,p_version_scn=>4063017195835
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(64126527824370343)
,p_plugin_type=>'PROCESS TYPE'
,p_plugin=>'NATIVE_GEOCODING'
,p_attribute_01=>'RELAX_HOUSE_NUMBER'
,p_version_scn=>4063017195837
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(64139058416370344)
,p_plugin_type=>'DYNAMIC ACTION'
,p_plugin=>'NATIVE_OPEN_AI_ASSISTANT'
,p_version_scn=>4063017195841
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(165638134440953114)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_MAP_REGION'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_vector_tile_layers', 'Y')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(166311384667150063)
,p_plugin_type=>'WEB SOURCE TYPE'
,p_plugin=>'NATIVE_ADFBC'
,p_version_scn=>3995516629607
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(166892052899665178)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_GEOCODED_ADDRESS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'background', 'default',
  'display_as', 'LIST',
  'map_preview', 'POPUP:ITEM',
  'match_mode', 'RELAX_HOUSE_NUMBER',
  'show_coordinates', 'N')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236496397075961927)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_DISPLAY_SELECTOR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'include_slider', 'Y')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236496704859961927)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_DATE_PICKER_APEX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_behavior', 'MONTH-PICKER:YEAR-PICKER',
  'days_outside_month', 'VISIBLE',
  'show_on', 'FOCUS',
  'time_increment', '15')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236497042248961927)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_SINGLE_CHECKBOX'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'checked_value', 'Y',
  'unchecked_value', 'N')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236497295411961927)
,p_plugin_type=>'REGION TYPE'
,p_plugin=>'NATIVE_IR'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'actions_menu_structure', 'IG')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236498281516961928)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_COLOR_PICKER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'mode', 'FULL')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236498577276961928)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_STAR_RATING'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_icon', 'fa-star',
  'tooltip', '#VALUE#')).to_clob
,p_version_scn=>1
);
wwv_flow_imp_shared.create_plugin_setting(
 p_id=>wwv_flow_imp.id(236498888556961929)
,p_plugin_type=>'ITEM TYPE'
,p_plugin=>'NATIVE_YES_NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_style', 'SWITCH',
  'off_label', 'Nein',
  'off_value', '0',
  'on_label', 'Ja',
  'on_value', '1')).to_clob
,p_version_scn=>1
);
wwv_flow_imp.component_end;
end;
/
