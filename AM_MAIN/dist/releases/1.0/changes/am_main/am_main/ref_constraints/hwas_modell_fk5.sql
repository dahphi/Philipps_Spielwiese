-- liquibase formatted sql
-- changeset AM_MAIN:1774600122655 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/hwas_modell_fk5.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_modell_fk5.sql:null:3118a2fb54940a2399c117b07f3f9baa59d89947:create

alter table am_main.hwas_modell
    add constraint hwas_modell_fk5
        foreign key ( hst_uid )
            references am_main.hwas_hersteller ( hst_uid )
        enable;

