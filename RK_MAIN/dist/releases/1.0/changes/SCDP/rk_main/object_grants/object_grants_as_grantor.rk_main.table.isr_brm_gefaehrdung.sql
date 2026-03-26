-- liquibase formatted sql
-- changeset RK_MAIN:1774561690578 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql:null:70d58d85c807ecec040f6a776c4a0076f874ea46:create

grant read on rk_main.isr_brm_gefaehrdung to awh_read_jira;

grant select on rk_main.isr_brm_gefaehrdung to rk_apex;

grant read on rk_main.isr_brm_gefaehrdung to rk_read;

