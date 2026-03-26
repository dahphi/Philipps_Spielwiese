-- liquibase formatted sql
-- changeset RK_MAIN:1774555708302 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum.sql:null:1da581353f8fec83fc020e43e89366e1f9d4d309:create

grant read on am_main.itwo_raum to rk_main;

