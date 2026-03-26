-- liquibase formatted sql
-- changeset am_main:1774557115476 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_netzebene.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_netzebene.sql:null:f121e5f98917886428d8fcc4d9e178a0164538a4:create

comment on table am_main.hwas_netzebene is
    'Diese Tabelle wird nicht mehr genutzt. Se ist nur noch zum Nachlagen vorhanen.';

comment on column am_main.hwas_netzebene.inserted is
    'Insert Datum';

comment on column am_main.hwas_netzebene.inserted_by is
    'Insert User';

comment on column am_main.hwas_netzebene.ne_beschreibung is
    'Beschreibung der Netzebene';

comment on column am_main.hwas_netzebene.ne_bezeichnung is
    'Bezeichnung der Netzebene';

comment on column am_main.hwas_netzebene.ne_uid is
    'Primärschlüssel';

comment on column am_main.hwas_netzebene.updated is
    'Update Datum';

comment on column am_main.hwas_netzebene.updated_by is
    'Update User';

