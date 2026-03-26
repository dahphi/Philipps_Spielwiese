-- liquibase formatted sql
-- changeset RK_MAIN:1774561690483 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.ad_abteilung.sql:null:d9dfb95fbe85416a00dfeedae923b896900a3353:create

grant select on rk_main.ad_abteilung to rk_apex;

grant read on rk_main.ad_abteilung to rk_read;

