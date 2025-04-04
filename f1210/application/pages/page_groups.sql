prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(236649969149962002)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
