-- liquibase formatted sql
-- changeset RK_MAIN:1774554920747 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/isr_oam_massnahmenkatalog_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/isr_oam_massnahmenkatalog_fk1.sql:null:e7f56a991120c514024c978fbaa42dfda9e23fe5:create

alter table rk_main.isr_oam_massnahmenkatalog
    add constraint isr_oam_massnahmenkatalog_fk1
        foreign key ( rsk_uid )
            references rk_main.isr_oam_risikoinventar ( rsk_uid )
        enable;

