-- liquibase formatted sql
-- changeset RK_MAIN:1774561789282 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilungsaccount.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilungsaccount.sql:e913a74694650e74aefebc074392435704efdd60:5ad51f21faf200cc68a056871ad91289a7bd43db:alter

grant select on rk_main.ad_abteilungsaccount to rk_apex;

