-- liquibase formatted sql
-- changeset AM_MAIN:1774557120551 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_modell_fk6.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_modell_fk6.sql:null:ccf8ba263073ff7c90937f21dd8a7a1fa305818a:create

alter table am_main.hwas_modell
    add constraint hwas_modell_fk6
        foreign key ( gkl_uid )
            references am_main.hwas_geraeteklasse ( gkl_uid )
        enable;

