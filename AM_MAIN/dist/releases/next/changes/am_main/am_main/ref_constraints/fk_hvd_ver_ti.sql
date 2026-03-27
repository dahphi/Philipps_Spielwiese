-- liquibase formatted sql
-- changeset AM_MAIN:1774605607138 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hvd_ver_ti.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvd_ver_ti.sql:null:7597e427ffe7eec5f7b92a4e33959c54fbd58d9e:create

alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_ver_ti
        foreign key ( ver_ti_uid_fk )
            references am_main.hwas_vertrag_titel ( ver_ti_uid )
        enable;

