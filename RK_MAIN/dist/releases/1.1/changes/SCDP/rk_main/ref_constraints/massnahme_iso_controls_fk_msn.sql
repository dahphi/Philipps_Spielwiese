-- liquibase formatted sql
-- changeset RK_MAIN:1774555712871 stripComments:false logicalFilePath:SCDP/rk_main/ref_constraints/massnahme_iso_controls_fk_msn.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/ref_constraints/massnahme_iso_controls_fk_msn.sql:null:450bffd3c9aab29010d13eba98267d9b16dd8eb2:create

alter table rk_main.isr_massnahme_iso_27001
    add constraint massnahme_iso_controls_fk_msn
        foreign key ( msn_uid )
            references rk_main.isr_oam_massnahme ( msn_uid )
        enable;

