-- liquibase formatted sql
-- changeset RK_MAIN:1774561789409 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_umsetzungsstatus.sql:83083b399199c92e44999252879e2e967e96750d:7604506dd33dfea3490773bdac6ce3d6ae495416:alter

grant select on rk_main.isr_oam_umsetzungsstatus to rk_apex;

grant select on rk_main.isr_oam_umsetzungsstatus to awh_apex;

