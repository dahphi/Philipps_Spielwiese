-- liquibase formatted sql
-- changeset RK_MAIN:1774561694662 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_asset_geefahren.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_asset_geefahren.sql:null:f0e3057db49c9e3e927aa9097c53609b61839b20:create

create table rk_main.isr_asset_geefahren (
    asge_uid   number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    asset_uid  number,
    gef_uid    number,
    gefaehrdet number
)
no inmemory;

alter table rk_main.isr_asset_geefahren
    add constraint isr_asset_geefahren_pk primary key ( asge_uid )
        using index enable;

