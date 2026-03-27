-- liquibase formatted sql
-- changeset AM_MAIN:1774600122546 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/hwas_funktionsklasse_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_funktionsklasse_fk2.sql:null:7480e51b6dcfb49c3f2abe29c6e1b2c26b86747a:create

alter table am_main.hwas_funktionsklasse
    add constraint hwas_funktionsklasse_fk2
        foreign key ( tkt_uid )
            references am_main.hwas_tk_technologie ( tkt_uid )
        enable;

