-- liquibase formatted sql
-- changeset RK_MAIN:1774555709117 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangelog.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangelog.sql:null:aa15a1993fa07b5ada29ec22279b8bb5f3b8bc1c:create

grant select on rk_main.databasechangelog to rk_apex;

