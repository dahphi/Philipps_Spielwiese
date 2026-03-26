-- liquibase formatted sql
-- changeset RK_MAIN:1774555712837 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk2.sql:null:372667466435dffeb5e009f0813675d8a22b4028:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk2
        foreign key ( rkt_uid )
            references rk_main.isr_oam_risikokategorie_oa ( rkt_uid )
        enable;

