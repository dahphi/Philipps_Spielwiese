-- liquibase formatted sql
-- changeset AM_MAIN:1774600100188 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_betriebssystem.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_betriebssystem.sql:null:d660ec9a70071794f38ef274f9474cef6292b6e2:create

grant read on am_main.hwas_betriebssystem to am_apex;

