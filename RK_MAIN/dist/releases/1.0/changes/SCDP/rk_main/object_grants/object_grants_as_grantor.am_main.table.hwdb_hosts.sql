-- liquibase formatted sql
-- changeset RK_MAIN:1774561689653 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwdb_hosts.sql:null:0a161d30fadc07a9d6689d850088e935581499f3:create

grant read on am_main.hwdb_hosts to rk_main;

