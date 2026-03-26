-- liquibase formatted sql
-- changeset am_main:1774556567730 stripComments:false logicalFilePath:SCDP/am_main/comments/itwo_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/itwo_raum.sql:null:d619135f552ffb05de8a07f40c043ff6a8a207fe:create

comment on column am_main.itwo_raum.raum is
    'Raumbezeichnung';

comment on column am_main.itwo_raum.site is
    'Verweis auf ITWO_SITE';

comment on column am_main.itwo_raum.standortpfad is
    'logischer Pfad zum Raum';

