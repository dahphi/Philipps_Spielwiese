-- liquibase formatted sql
-- changeset AM_MAIN:1774556568098 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozess_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozess_system.sql:null:72c515398d9d36f5b39b98b2ecbbc1c6999acdda:create

grant select on am_main.hwas_prozess_system to am_apex;

