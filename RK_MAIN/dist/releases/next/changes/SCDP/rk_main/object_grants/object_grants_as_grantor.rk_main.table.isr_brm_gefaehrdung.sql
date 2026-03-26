-- liquibase formatted sql
-- changeset RK_MAIN:1774555709151 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql:null:8176befc9ca01dafb237ecf6784345f76c0b1951:create

grant select on rk_main.isr_brm_gefaehrdung to rk_apex;

grant read on rk_main.isr_brm_gefaehrdung to awh_read_jira;

grant read on rk_main.isr_brm_gefaehrdung to rk_read;

