-- liquibase formatted sql
-- changeset RK_MAIN:1774554916859 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme.sql:null:4248b74e9b5e0fcc7610d1bd47771ba00cd176aa:create

grant select on rk_main.isr_oam_massnahme to rk_apex;

grant select on rk_main.isr_oam_massnahme to awh_apex;

grant read on rk_main.isr_oam_massnahme to awh_read_jira;

grant read on rk_main.isr_oam_massnahme to rk_read;

