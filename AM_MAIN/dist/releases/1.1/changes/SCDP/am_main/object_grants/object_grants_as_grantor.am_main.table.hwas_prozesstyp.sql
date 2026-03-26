-- liquibase formatted sql
-- changeset AM_MAIN:1774557115981 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozesstyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozesstyp.sql:null:48de9a8f7e336d3957dd198748dc9174d0444303:create

grant select on am_main.hwas_prozesstyp to am_apex;

grant select on am_main.hwas_prozesstyp to awh_apex;

grant read on am_main.hwas_prozesstyp to awh_read_jira;

