-- liquibase formatted sql
-- changeset AM_MAIN:1774557120510 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_betriebsinterner_prozess_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_betriebsinterner_prozess_fk1.sql:null:6745d5e07d9e6aa7f1c700ed7f097c3ae24e8843:create

alter table am_main.hwas_betriebsinterner_prozess
    add constraint hwas_betriebsinterner_prozess_fk1
        foreign key ( ak3_uid )
            references am_main.hwas_anlagenkategorie_e3 ( ak3_uid )
        enable;

