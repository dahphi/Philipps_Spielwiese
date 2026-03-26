-- liquibase formatted sql
-- changeset RK_MAIN:1774555712831 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk1.sql:null:eea6ab51474b8fa68b3d38379ffc93c9ce233fd9:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk1
        foreign key ( gef_uid )
            references rk_main.isr_brm_gefaehrdung ( gef_uid )
        enable;

