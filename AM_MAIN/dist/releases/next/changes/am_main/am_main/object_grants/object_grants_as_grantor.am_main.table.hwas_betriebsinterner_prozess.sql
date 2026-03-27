-- liquibase formatted sql
-- changeset AM_MAIN:1774600100175 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_betriebsinterner_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_betriebsinterner_prozess.sql:null:031d297d64a20e829d8d13b03edc26e792708b43:create

grant select on am_main.hwas_betriebsinterner_prozess to am_apex;

