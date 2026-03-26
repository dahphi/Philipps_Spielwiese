-- liquibase formatted sql
-- changeset AM_MAIN:1774557120504 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_bereich_e2_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_bereich_e2_fk1.sql:null:67cf1074200c57cb70a114361314ae1a36bbc1d8:create

alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_fk1
        foreign key ( kd1_uid )
            references am_main.hwas_krit_dienstlstg_e1 ( kd1_uid )
        enable;

