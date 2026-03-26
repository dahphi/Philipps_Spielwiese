-- liquibase formatted sql
-- changeset RK_MAIN:1774554920741 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_asset_geefahren_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_asset_geefahren_fk1.sql:null:c9f7633a56fa3add2307bfe3df75cebfff752d86:create

alter table rk_main.isr_asset_geefahren
    add constraint isr_asset_geefahren_fk1
        foreign key ( gef_uid )
            references rk_main.isr_brm_gefaehrdung ( gef_uid )
        enable;

