-- liquibase formatted sql
-- changeset AM_MAIN:1774557120575 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_tk_technologie_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_tk_technologie_fk2.sql:null:70e347a18de028eee7af8a64816556468c533fc9:create

alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk2
        foreign key ( ak3_uid )
            references am_main.hwas_anlagenkategorie_e3 ( ak3_uid )
        enable;

