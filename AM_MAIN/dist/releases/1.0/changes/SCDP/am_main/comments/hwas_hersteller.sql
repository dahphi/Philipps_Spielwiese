-- liquibase formatted sql
-- changeset am_main:1774556567485 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_hersteller.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_hersteller.sql:null:3397751b3d10d9d69157b3406ea373f8276d731a:create

comment on column am_main.hwas_hersteller.hst_beschreibung is
    'Beschreibung des Herstellers';

comment on column am_main.hwas_hersteller.hst_bezeichnung is
    'Hersteller-Bezeichnung';

comment on column am_main.hwas_hersteller.hst_uid is
    'Primärschlüssel';

comment on column am_main.hwas_hersteller.hst_url is
    'URL zur Web-Seite des Herstellers';

comment on column am_main.hwas_hersteller.inserted is
    'Insert Datum';

comment on column am_main.hwas_hersteller.inserted_by is
    'Insert User';

comment on column am_main.hwas_hersteller.updated is
    'Update Datum';

comment on column am_main.hwas_hersteller.updated_by is
    'Update User';

