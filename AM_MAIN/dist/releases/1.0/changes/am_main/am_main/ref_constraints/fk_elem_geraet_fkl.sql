-- liquibase formatted sql
-- changeset AM_MAIN:1774600122015 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/fk_elem_geraet_fkl.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/fk_elem_geraet_fkl.sql:null:bbc5015b43b6b59ff17cefe2f8dd5a0378b351d1:create

alter table am_main.hwas_elem_geraet
    add constraint fk_elem_geraet_fkl
        foreign key ( fkl_uid )
            references am_main.hwas_funktionsklasse ( fkl_uid )
        enable;

