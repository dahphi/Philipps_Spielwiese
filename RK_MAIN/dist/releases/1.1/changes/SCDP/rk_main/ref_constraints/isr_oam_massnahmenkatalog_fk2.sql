-- liquibase formatted sql
-- changeset RK_MAIN:1774555712826 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_massnahmenkatalog_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_massnahmenkatalog_fk2.sql:null:e268ba41a66b01ddabcaebe587ae884fd7dc1b2b:create

alter table rk_main.isr_oam_massnahmenkatalog
    add constraint isr_oam_massnahmenkatalog_fk2
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;

