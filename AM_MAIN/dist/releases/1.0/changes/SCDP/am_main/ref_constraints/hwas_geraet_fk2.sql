-- liquibase formatted sql
-- changeset AM_MAIN:1774556572376 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_geraet_fk2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_geraet_fk2.sql:null:af1a08442fcf1dc04e8ab0c70951f34bf8e6129a:create

alter table am_main.hwas_geraet
    add constraint hwas_geraet_fk2
        foreign key ( rm_uid )
            references am_main.hwas_raum ( rm_uid )
        enable;

