-- liquibase formatted sql
-- changeset AM_MAIN:1774556572411 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_raum_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_raum_fk1.sql:null:95e404d21db4d832d4d16cd7bbf93c92cfd1e091:create

alter table am_main.hwas_raum
    add constraint hwas_raum_fk1
        foreign key ( geb_uid )
            references am_main.hwas_gebaeude ( geb_uid )
        enable;

