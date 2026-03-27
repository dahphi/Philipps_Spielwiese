-- liquibase formatted sql
-- changeset AM_MAIN:1774600122059 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_havd_vd.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_havd_vd.sql:null:19cd621fc8141ca907dc86442eb103889257a5e5:create

alter table am_main.hwas_asset_vertragsdetails
    add constraint fk_havd_vd
        foreign key ( vd_uid_fk )
            references am_main.hwas_vertragsdetails ( vd_uid )
        enable;

