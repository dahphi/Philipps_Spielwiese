-- liquibase formatted sql
-- changeset AM_MAIN:1774600101834 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum.sql:null:443a0b129dcd8494c670f5c529e60ada3a80259a:create

grant select on am_main.itwo_raum to am_apex;

grant select on am_main.itwo_raum to rk_apex;

grant read on am_main.itwo_raum to rk_apex;

grant read on am_main.itwo_raum to rk_main;

