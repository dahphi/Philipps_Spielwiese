-- liquibase formatted sql
-- changeset rk_main:1774555708575 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_auswirkung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_auswirkung.sql:null:da4d18cf3785f208fd61ed235d6ccd17cba08428:create

comment on column rk_main.isr_auswirkung.auw_bezeichnung is
    'Bezeichnung';

comment on column rk_main.isr_auswirkung.auw_kriterien is
    'Kritierien für die Einordnund in die Auswirkung';

comment on column rk_main.isr_auswirkung.auw_uid is
    'Primärschlüssel';

comment on column rk_main.isr_auswirkung.auw_wert is
    'Wert der Auswirkung für Berechnungen';

comment on column rk_main.isr_auswirkung.inserted is
    'Insert Datum';

comment on column rk_main.isr_auswirkung.inserted_by is
    'Insert User';

comment on column rk_main.isr_auswirkung.updated is
    'Update Datum';

comment on column rk_main.isr_auswirkung.updated_by is
    'Update User';

