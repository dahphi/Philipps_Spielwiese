-- liquibase formatted sql
-- changeset RK_MAIN:1774561690719 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql:null:ddf30986d59f8bda441ae7405d4a0f08a14dfa3e:create

grant read on rk_main.isr_oam_umsetzungsstatus to awh_read_jira;

grant select on rk_main.isr_oam_umsetzungsstatus to rk_apex;

grant read on rk_main.isr_oam_umsetzungsstatus to rk_read;

grant select on rk_main.isr_oam_umsetzungsstatus to awh_apex;

