-- liquibase formatted sql
-- changeset rk_main:1774555708551 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_asset_geefahren.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_asset_geefahren.sql:null:5dc392f59e785a7f5620650a785974a918112192:create

comment on column rk_main.isr_asset_geefahren.asge_uid is
    'Primärschlüssel';

comment on column rk_main.isr_asset_geefahren.asset_uid is
    'Fremschlüssel Asset (auf am_main.V_ASSET)';

comment on column rk_main.isr_asset_geefahren.gefaehrdet is
    'NULL = nicht bewertet, 0 nicht gefaehrdet, 1 gefaehrdet';

comment on column rk_main.isr_asset_geefahren.gef_uid is
    'Fremschlüssel Gefährudnung';

