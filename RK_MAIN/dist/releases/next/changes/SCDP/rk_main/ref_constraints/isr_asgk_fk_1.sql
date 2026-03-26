-- liquibase formatted sql
-- changeset RK_MAIN:1774554920727 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_asgk_fk_1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_asgk_fk_1.sql:null:583a7933c7ba664a7389a87410e7ce7558386612:create

alter table rk_main.isr_assettypen_gefaehrdungkat
    add constraint isr_asgk_fk_1
        foreign key ( ast_uid )
            references rk_main.asm_am_assettypen ( ast_uid )
        enable;

