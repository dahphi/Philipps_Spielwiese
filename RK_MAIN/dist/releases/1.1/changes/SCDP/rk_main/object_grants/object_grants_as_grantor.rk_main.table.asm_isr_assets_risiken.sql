-- liquibase formatted sql
-- changeset RK_MAIN:1774561789303 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_isr_assets_risiken.sql:baaee1159734cfd3773f8ac7c496c0c862017a1c:8adee83049f86d3cc4e114590774a1e25b482ac0:alter

grant select on rk_main.asm_isr_assets_risiken to rk_apex;

grant select on rk_main.asm_isr_assets_risiken to awh_main;

grant select on rk_main.asm_isr_assets_risiken to awh_apex;

grant select on rk_main.asm_isr_assets_risiken to am_apex;

