-- liquibase formatted sql
-- changeset RK_MAIN:1774554920780 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk4.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk4.sql:null:1436f31da8157db0553f4079d5547bcfdf8b84ba:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk4
        foreign key ( netto2_ews_uid )
            references rk_main.isr_eintrittswahrscheinlichkeit ( ews_uid )
        enable;

