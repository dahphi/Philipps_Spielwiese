-- liquibase formatted sql
-- changeset RK_MAIN:1774561789278 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilung.sql:0deec9f78cc9e9985b0499cae40c2d379b6feae5:d9dfb95fbe85416a00dfeedae923b896900a3353:alter

grant select on rk_main.ad_abteilung to rk_apex;

