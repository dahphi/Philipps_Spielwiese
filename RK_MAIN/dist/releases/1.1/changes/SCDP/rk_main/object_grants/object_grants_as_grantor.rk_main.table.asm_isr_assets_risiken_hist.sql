-- liquibase formatted sql
-- changeset RK_MAIN:1774555709114 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken_hist.sql:null:6da6dcfb99a6a1beb67d2ec4aacf1d8d142177d9:create

grant select on rk_main.asm_isr_assets_risiken_hist to rk_apex;

