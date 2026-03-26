-- liquibase formatted sql
-- changeset AM_MAIN:1774556568127 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_rufbereitschaft.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_rufbereitschaft.sql:null:666fd135524703ca9ab5fa99f560d128fd246ee8:create

grant select on am_main.hwas_rufbereitschaft to am_apex;

grant read on am_main.hwas_rufbereitschaft to awh_read_jira;

