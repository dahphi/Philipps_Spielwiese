-- liquibase formatted sql
-- changeset RK_MAIN:1774554916782 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_schwachstellenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_schwachstellenkat.sql:null:9b0af75da3f6224218baf9a779ad305d3e61268a:create

grant select on rk_main.isr_brm_schwachstellenkat to rk_apex;

grant read on rk_main.isr_brm_schwachstellenkat to awh_read_jira;

grant read on rk_main.isr_brm_schwachstellenkat to rk_read;

