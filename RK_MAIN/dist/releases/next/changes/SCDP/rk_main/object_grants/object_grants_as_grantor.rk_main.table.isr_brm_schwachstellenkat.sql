-- liquibase formatted sql
-- changeset RK_MAIN:1774561690596 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_schwachstellenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_schwachstellenkat.sql:null:e19d3732d97d4fdc9ca8faea074276c138be4e36:create

grant read on rk_main.isr_brm_schwachstellenkat to awh_read_jira;

grant select on rk_main.isr_brm_schwachstellenkat to rk_apex;

grant read on rk_main.isr_brm_schwachstellenkat to rk_read;

