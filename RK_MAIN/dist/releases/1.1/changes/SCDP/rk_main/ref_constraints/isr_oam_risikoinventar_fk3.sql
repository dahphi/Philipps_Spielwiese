-- liquibase formatted sql
-- changeset RK_MAIN:1774555712843 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_risikoinventar_fk3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_risikoinventar_fk3.sql:null:e9c3ca1517f97d538507634c1539a17e1fc72a03:create

alter table rk_main.isr_oam_risikoinventar
    add constraint isr_oam_risikoinventar_fk3
        foreign key ( netto1_ews_uid )
            references rk_main.isr_eintrittswahrscheinlichkeit ( ews_uid )
        enable;

