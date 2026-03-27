-- liquibase formatted sql
-- changeset AM_MAIN:1774600122809 stripComments:false logicalFilePath:am_main/am_main/ref_constraints/hwas_tk_technologie_fk3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/ref_constraints/hwas_tk_technologie_fk3.sql:null:49f6774eee1a7da790e8e573f509d5cad7dc61ac:create

alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_fk3
        foreign key ( krk_uid )
            references am_main.hwas_kritikalitaet ( krk_uid )
        enable;

