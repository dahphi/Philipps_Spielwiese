-- liquibase formatted sql
-- changeset am_main:1774557115506 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_raum.sql:null:c23c85dbe3c0245a0abc257c47071e7f6435ad14:create

comment on column am_main.hwas_raum.geb_uid is
    'Fremdschlüssel Gebäude';

comment on column am_main.hwas_raum.inserted is
    'Insert Datum';

comment on column am_main.hwas_raum.inserted_by is
    'Insert User';

comment on column am_main.hwas_raum.raum is
    'Fremdschlüssel ITWO_RAUM';

comment on column am_main.hwas_raum.rm_beschreibung is
    'Beschreibung des Raums';

comment on column am_main.hwas_raum.rm_uid is
    'Primärschlüssel';

comment on column am_main.hwas_raum.updated is
    'Update Datum';

comment on column am_main.hwas_raum.updated_by is
    'Update User';

