-- liquibase formatted sql
-- changeset RK_MAIN:1774561789417 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql:cf052bd52688cfa898b57308c01c261bc7d41368:2d74b7f5dde953c82a463200ef3fcc637661cde1:alter

grant select on rk_main.isr_risiko_erkenntnisquelle to rk_apex;

