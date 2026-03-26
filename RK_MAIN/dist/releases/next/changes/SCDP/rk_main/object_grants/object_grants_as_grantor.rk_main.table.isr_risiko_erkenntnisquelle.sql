-- liquibase formatted sql
-- changeset RK_MAIN:1774561690735 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql:null:3826dc9d4dd3e40fb8fc18ebecee7de2e7577267:create

grant read on rk_main.isr_risiko_erkenntnisquelle to awh_read_jira;

grant select on rk_main.isr_risiko_erkenntnisquelle to rk_apex;

grant read on rk_main.isr_risiko_erkenntnisquelle to rk_read;

