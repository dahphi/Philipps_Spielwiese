prompt --application/shared_components/files/l_control_locate_min_css
begin
--   Manifest
--     APP STATIC FILES: 1210
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E6C6561666C65742D636F6E74726F6C2D6C6F6361746520617B666F6E742D73697A653A312E34656D3B636F6C6F723A233434343B637572736F723A706F696E7465727D2E6C6561666C65742D636F6E74726F6C2D6C6F636174652E6163746976652061';
wwv_flow_imp.g_varchar2_table(2) := '7B636F6C6F723A233230373442367D2E6C6561666C65742D636F6E74726F6C2D6C6F636174652E6163746976652E666F6C6C6F77696E6720617B636F6C6F723A234643383432387D0A2F2A2320736F757263654D617070696E6755524C3D4C2E436F6E74';
wwv_flow_imp.g_varchar2_table(3) := '726F6C2E4C6F636174652E6D696E2E6373732E6D6170202A2F0A';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(236701394223995777)
,p_file_name=>'L.Control.Locate.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
