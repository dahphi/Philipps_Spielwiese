-- liquibase formatted sql
-- changeset RK_MAIN:1774561789286 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_asset.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_asset.sql:339b6c3fd70cf8194155b02e8cd396d3d2790074:7ca5be0b946684e283a675b16d0608b2a5db8421:alter

grant select on rk_main.asm_am_asset to am_apex;

grant select on rk_main.asm_am_asset to rk_apex;

