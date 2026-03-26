-- liquibase formatted sql
-- changeset AM_MAIN:1774556568161 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_virtuelle_maschinen.sql:null:17a25a8efbb9b9bb5eb273c5ae65d2908cb4d02b:create

grant select on am_main.hwas_virtuelle_maschinen to am_apex;

grant select on am_main.hwas_virtuelle_maschinen to rk_apex;

grant read on am_main.hwas_virtuelle_maschinen to rk_apex;

grant read on am_main.hwas_virtuelle_maschinen to rk_main;

grant read on am_main.hwas_virtuelle_maschinen to awh_read_jira;

