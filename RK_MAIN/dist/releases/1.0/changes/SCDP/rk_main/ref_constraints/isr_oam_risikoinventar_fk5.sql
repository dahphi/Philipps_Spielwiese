-- liquibase formatted sql
-- changeset RK_MAIN:1774561694385 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk5.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk5.sql:null:21066caac720fea94cfcf6146ff8a2bb76133fa9:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk5
        foreign key ( netto1_auw_uid )
            references rk_main.isr_auswirkung ( auw_uid )
        enable;

