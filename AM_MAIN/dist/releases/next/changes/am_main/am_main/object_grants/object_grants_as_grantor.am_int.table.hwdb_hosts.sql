-- liquibase formatted sql
-- changeset AM_MAIN:1774600096872 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_int.table.hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_int/object_grants/object_grants_as_grantor.am_int.table.hwdb_hosts.sql:null:ce2450573035c3be7d39d9ff30611a06adba9492:create

grant select on am_int.hwdb_hosts to am_main;

