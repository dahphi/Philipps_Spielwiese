-- liquibase formatted sql
-- changeset AM_MAIN:1774600100350 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_funktionsklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_funktionsklasse.sql:null:82a218122df603866df5020d9dd44b4eaf3c09b2:create

grant select on am_main.hwas_funktionsklasse to am_apex;

grant select on am_main.hwas_funktionsklasse to awh_apex;

grant select on am_main.hwas_funktionsklasse to rk_apex;

grant read on am_main.hwas_funktionsklasse to awh_apex;

grant read on am_main.hwas_funktionsklasse to rk_main;

grant read on am_main.hwas_funktionsklasse to rk_apex;

grant read on am_main.hwas_funktionsklasse to awh_read_jira;

