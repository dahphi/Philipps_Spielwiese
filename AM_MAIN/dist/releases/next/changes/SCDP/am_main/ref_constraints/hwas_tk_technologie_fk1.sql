-- liquibase formatted sql
-- changeset AM_MAIN:1774556572417 stripComments:false logicalFilePath:SCDP/am_main/ref_constraints/hwas_tk_technologie_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_tk_technologie_fk1.sql:null:d19f9745b97867a2b4fb5edf8ab0754668e52aa6:create

alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk1
        foreign key ( bip_uid )
            references am_main.hwas_betriebsinterner_prozess ( bip_uid )
        enable;

