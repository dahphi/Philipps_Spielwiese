-- liquibase formatted sql
-- changeset am_main:1774556567542 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_kritikalitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_kritikalitaet.sql:null:3ec809065744f13b0dc295dfcdde1bc8967147fa:create

comment on column am_main.hwas_kritikalitaet.inserted is
    'Insert Datum';

comment on column am_main.hwas_kritikalitaet.inserted_by is
    'Insert User';

comment on column am_main.hwas_kritikalitaet.krk_bezeichnung is
    'eindeutige Bezeichnung';

comment on column am_main.hwas_kritikalitaet.krk_erlaeuterungen is
    'Erläuteurngen';

comment on column am_main.hwas_kritikalitaet.krk_kurzbeschreibung is
    'Kurzbeschreibung';

comment on column am_main.hwas_kritikalitaet.updated is
    'Update Datum';

comment on column am_main.hwas_kritikalitaet.updated_by is
    'Update User';

