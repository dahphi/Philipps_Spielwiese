-- liquibase formatted sql
-- changeset RK_MAIN:1774561690496 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_asset.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_asset.sql:null:937db5246ea9bc5048818300b7d13a628ffd0ed7:create

grant select on rk_main.asm_am_asset to rk_apex;

grant read on rk_main.asm_am_asset to rk_read;

grant read on rk_main.asm_am_asset to rk_apex;

grant select on rk_main.asm_am_asset to am_apex;

grant read on rk_main.asm_am_asset to awh_read_jira;

