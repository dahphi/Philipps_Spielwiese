-- liquibase formatted sql
-- changeset RK_MAIN:1774561694416 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/massnahme_kontext_fk_msn.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/massnahme_kontext_fk_msn.sql:null:d1e488899f6444acfc461ef3a1160eb12a8bcbac:create

alter table rk_main.isr_massnahme_kontext
    add constraint massnahme_kontext_fk_msn
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;

