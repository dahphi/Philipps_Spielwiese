-- liquibase formatted sql
-- changeset AM_MAIN:1774557120355 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/fk_fkl_uid.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_fkl_uid.sql:null:b07f19ebf263691926a27bbc2e82c99aab1faa0a:create

alter table am_main.hwas_bean_funktionsklassen
    add constraint fk_fkl_uid
        foreign key ( fkl_uid_fk )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        enable;

