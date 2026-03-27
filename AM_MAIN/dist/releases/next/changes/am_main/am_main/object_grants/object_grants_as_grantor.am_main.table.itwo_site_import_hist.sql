-- liquibase formatted sql
-- changeset AM_MAIN:1774600101958 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site_import_hist.sql:null:027e1c3fb6cc7b8b43d773ba886a000c300e12b8:create

grant select on am_main.itwo_site_import_hist to am_apex;

