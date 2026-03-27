-- liquibase formatted sql
-- changeset AM_MAIN:1774600101811 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts_import_hist.sql:null:74852b4f87e59e4685bdc679121265977cd863b8:create

grant select on am_main.hwdb_hosts_import_hist to am_apex;

