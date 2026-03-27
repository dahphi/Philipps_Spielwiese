-- liquibase formatted sql
-- changeset AM_MAIN:1774600122102 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hlv_vd.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hlv_vd.sql:null:4d836c0f97f5fc79cafc4ea38a3b0f13eb974e41:create

alter table am_main.hwas_lieferant_vertragsdetail
    add constraint fk_hlv_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;

