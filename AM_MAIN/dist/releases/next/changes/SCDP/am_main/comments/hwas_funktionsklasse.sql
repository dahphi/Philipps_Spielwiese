-- liquibase formatted sql
-- changeset am_main:1774556567363 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_funktionsklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_funktionsklasse.sql:null:83560996073635ee11488c30dec3dc9d2b9cc86a:create

comment on column am_main.hwas_funktionsklasse.fkl_beschreibung is
    'Funktionsklasse Beschreibung';

comment on column am_main.hwas_funktionsklasse.fkl_bezeichnung is
    'Funktionsklasse-Bezeichnung';

comment on column am_main.hwas_funktionsklasse.fkl_kritis_relevant is
    'Assets der Funktionsklasse sind kritis-relefant; 1=ja, 0=nein';

comment on column am_main.hwas_funktionsklasse.fkl_uid is
    'Primärschlüssel';

comment on column am_main.hwas_funktionsklasse.inserted is
    'Insert Datum';

comment on column am_main.hwas_funktionsklasse.inserted_by is
    'Insert User';

comment on column am_main.hwas_funktionsklasse.ruf_uid is
    'Fremdschlüssel Rufbereitschaften';

comment on column am_main.hwas_funktionsklasse.tkt_uid is
    'Fremdschlüssel TK-Technologie';

comment on column am_main.hwas_funktionsklasse.updated is
    'Update Datum';

comment on column am_main.hwas_funktionsklasse.updated_by is
    'Update User';

