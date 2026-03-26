-- liquibase formatted sql
-- changeset RK_MAIN:1774561690552 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_asset_geefahren.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_asset_geefahren.sql:null:9a6d89964bda76c4ac9fbabc6113d073d3701f9f:create

grant select on rk_main.isr_asset_geefahren to rk_apex;

grant read on rk_main.isr_asset_geefahren to rk_read;

