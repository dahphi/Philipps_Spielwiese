-- liquibase formatted sql
-- changeset RK_MAIN:1774555709300 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_risiko_erkenntnisquelle.sql:null:2d74b7f5dde953c82a463200ef3fcc637661cde1:create

grant select on rk_main.isr_risiko_erkenntnisquelle to rk_apex;

grant read on rk_main.isr_risiko_erkenntnisquelle to awh_read_jira;

grant read on rk_main.isr_risiko_erkenntnisquelle to rk_read;

