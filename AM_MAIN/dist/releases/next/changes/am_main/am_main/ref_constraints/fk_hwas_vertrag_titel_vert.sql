-- liquibase formatted sql
-- changeset AM_MAIN:1774600122338 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_hwas_vertrag_titel_vert.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_hwas_vertrag_titel_vert.sql:null:8ccc3eb3a33f42872de16fd5ab17a558e9e2b95e:create

alter table am_main.hwas_vertrag_titel
    add constraint fk_hwas_vertrag_titel_vert
        foreign key ( vert_uid_fk )
            references am_main.hwas_vertrag ( vert_uid )
        enable;

