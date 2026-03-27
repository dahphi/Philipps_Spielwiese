-- liquibase formatted sql
-- changeset am_main:1774600098751 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_netz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_netz.sql:null:546443faa07a86e2ca1684cb2b751a5cb148c85a:create

comment on table am_main.hwas_netz is
    'Diese Tabelle wird nicht mehr verwendet. Sie wird ggf. zum Nachlagne noch beibehalten.';

comment on column am_main.hwas_netz.ad_san_anspechpartner is
    'AD-Kürzel des Ansprechpartners';

comment on column am_main.hwas_netz.ak3_uid is
    'Fremdschlüssel Bereich/Kategorie';

comment on column am_main.hwas_netz.inserted is
    'Insert Datum';

comment on column am_main.hwas_netz.inserted_by is
    'Insert User';

comment on column am_main.hwas_netz.net_beschreibung is
    'Beschreibung des netzes';

comment on column am_main.hwas_netz.net_bezeichnung is
    'Netz-Bezeichnng';

comment on column am_main.hwas_netz.net_uid is
    'Primärschlüssel';

comment on column am_main.hwas_netz.tkt_uid is
    'Fremdschlüssel TK-Technologie';

comment on column am_main.hwas_netz.updated is
    'Update Datum';

comment on column am_main.hwas_netz.updated_by is
    'Update User';

