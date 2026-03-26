-- liquibase formatted sql
-- changeset RK_MAIN:1774555709287 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql:null:7604506dd33dfea3490773bdac6ce3d6ae495416:create

grant select on rk_main.isr_oam_umsetzungsstatus to rk_apex;

grant select on rk_main.isr_oam_umsetzungsstatus to awh_apex;

grant read on rk_main.isr_oam_umsetzungsstatus to awh_read_jira;

grant read on rk_main.isr_oam_umsetzungsstatus to rk_read;

