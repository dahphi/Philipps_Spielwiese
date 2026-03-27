-- liquibase formatted sql
-- changeset AM_MAIN:1774600122419 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_przp_vd.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_przp_vd.sql:null:a97d04c56de9b0b3da340ed786a8930bce86236f:create

alter table am_main.hwas_prozesse_vertragsdetails
    add constraint fk_przp_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;

