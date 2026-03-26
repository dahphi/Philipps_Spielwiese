-- liquibase formatted sql
-- changeset RK_MAIN:1774561689800 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.table.logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.logs.sql:null:82dead21b59d6da0579635408b8b5249eff3912a:create

grant select on core.logs to rk_main;

grant read on core.logs to rk_main;

