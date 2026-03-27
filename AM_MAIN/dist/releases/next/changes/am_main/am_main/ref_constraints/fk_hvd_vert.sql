-- liquibase formatted sql
-- changeset AM_MAIN:1774600122147 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hvd_vert.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hvd_vert.sql:null:0f3df0e39728b938dd46c14c5be96ed7635813d9:create

alter table am_main.hwas_vertragsdetails
    add constraint fk_hvd_vert
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;

