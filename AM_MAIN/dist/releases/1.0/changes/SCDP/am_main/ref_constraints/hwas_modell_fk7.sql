-- liquibase formatted sql
-- changeset AM_MAIN:1774556572405 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_modell_fk7.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_modell_fk7.sql:null:137c62e4554bbc091da35be1cdb801ae95d089e6:create

alter table am_main.hwas_modell
    add constraint hwas_modell_fk7
        foreign key ( fkl_uid )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        disable;

