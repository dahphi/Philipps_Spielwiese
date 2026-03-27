-- liquibase formatted sql
-- changeset am_main:1774600099326 stripComments:false logicalFilePath:am_main/am_main/comments/hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwdb_hosts.sql:null:e3f8ab8a33c63dd955842e7b4528ce243fce1c29:create

comment on column am_main.hwdb_hosts.inserted is
    'Insert Datum';

comment on column am_main.hwdb_hosts.inserted_by is
    'Insert User';

comment on column am_main.hwdb_hosts.status is
    'Lebenszyklus des Gerätes. Aktiv/inaktiv';

comment on column am_main.hwdb_hosts.updated is
    'Update Datum';

comment on column am_main.hwdb_hosts.updated_by is
    'Update User';

comment on column am_main.hwdb_hosts.valid_to is
    'Zeitpunkt des einfügens eines neuen Datensatzes mit demselben Schlüssel';

