-- liquibase formatted sql
-- changeset AM_MAIN:1774557122343 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.table.awh_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.table.awh_system.sql:null:fc019237fbc032d549fc9f7cec91acb595fbd396:create

grant select on awh_main.awh_system to am_main;

grant references on awh_main.awh_system to am_main;

