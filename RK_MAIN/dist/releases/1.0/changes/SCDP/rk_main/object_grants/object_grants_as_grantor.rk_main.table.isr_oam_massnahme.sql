-- liquibase formatted sql
-- changeset RK_MAIN:1774561690657 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme.sql:null:0205b6b078556b0af80063861dd52c3adb1b1c16:create

grant read on rk_main.isr_oam_massnahme to awh_read_jira;

grant select on rk_main.isr_oam_massnahme to rk_apex;

grant read on rk_main.isr_oam_massnahme to rk_read;

grant select on rk_main.isr_oam_massnahme to awh_apex;

