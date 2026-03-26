-- liquibase formatted sql
-- changeset RK_MAIN:1774561694390 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk6.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk6.sql:null:56df554f42cd36d129dd2d240dc6811237142448:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk6
        foreign key ( netto2_auw_uid )
            references rk_main.isr_auswirkung ( auw_uid )
        enable;

