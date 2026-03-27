-- liquibase formatted sql
-- changeset am_main:1774600099397 stripComments:false logicalFilePath:am_main/am_main/comments/itwo_site.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/itwo_site.sql:null:5f0316f9e4b142755f2c003d4b0c4cf74ddb3f4a:create

comment on column am_main.itwo_site.haus_nr is
    'Hausnummer des Gebäudes';

comment on column am_main.itwo_site.obj_id is
    'Primärschlüssel aus iTWO';

comment on column am_main.itwo_site.plz is
    'Postleitzahl';

comment on column am_main.itwo_site.site is
    'Site-Kürzel';

comment on column am_main.itwo_site.strasse is
    'Name der Straße';

