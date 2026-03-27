-- liquibase formatted sql
-- changeset am_main:1774600097031 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_bereich_e2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_bereich_e2.sql:null:6e0a0bb0594cc6037f572ccae9ddeb822aef76af:create

comment on column am_main.hwas_bereich_e2.be2_bezeichnung is
    'Bereichsname';

comment on column am_main.hwas_bereich_e2.be2_nummer is
    'Nummer Ebene 2 in der Dezimalklassifikation';

comment on column am_main.hwas_bereich_e2.be2_uid is
    'Primärschlüssel';

comment on column am_main.hwas_bereich_e2.inserted is
    'Insert Datum';

comment on column am_main.hwas_bereich_e2.inserted_by is
    'Insert User';

comment on column am_main.hwas_bereich_e2.kd1_uid is
    'Fremschlüssel Kritische Dienstleistung E1';

comment on column am_main.hwas_bereich_e2.updated is
    'Update Datum';

comment on column am_main.hwas_bereich_e2.updated_by is
    'Update User';

