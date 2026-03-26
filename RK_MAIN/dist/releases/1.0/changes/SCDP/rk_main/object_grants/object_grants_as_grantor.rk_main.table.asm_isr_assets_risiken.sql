-- liquibase formatted sql
-- changeset RK_MAIN:1774561690528 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken.sql:null:bd8b182410add4505e0f5483edb558e22cf3ad5f:create

grant read on rk_main.asm_isr_assets_risiken to awh_read_jira;

grant select on rk_main.asm_isr_assets_risiken to rk_apex;

grant read on rk_main.asm_isr_assets_risiken to rk_read;

grant select on rk_main.asm_isr_assets_risiken to awh_main;

grant select on rk_main.asm_isr_assets_risiken to awh_apex;

