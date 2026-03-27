-- liquibase formatted sql
-- changeset AM_MAIN:1774600122841 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/hwas_virtuelle_maschinen_fk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_virtuelle_maschinen_fk1.sql:null:e2447d68c7746f1b6fdcb53cbabd39fb7565dd58:create

alter table am_main.hwas_virtuelle_maschinen
    add constraint hwas_virtuelle_maschinen_fk1
        foreign key ( nzone_uid )
            references am_main.hwas_netzwerkzone ( nzone_uid )
        enable;

