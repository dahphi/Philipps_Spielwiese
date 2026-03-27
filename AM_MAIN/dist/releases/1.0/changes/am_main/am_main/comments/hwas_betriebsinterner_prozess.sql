-- liquibase formatted sql
-- changeset am_main:1774600097095 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_betriebsinterner_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_betriebsinterner_prozess.sql:null:a70b128f07dc1e6d4eac8fa59f753e6c87747548:create

comment on column am_main.hwas_betriebsinterner_prozess.ak3_uid is
    'Fremdschlüssel Anlagenkategorie';

comment on column am_main.hwas_betriebsinterner_prozess.bip_abhaenigkeit_logistik is
    'wesentliche Abhängigkeit Logistk, 0=nein, 1=ja';

comment on column am_main.hwas_betriebsinterner_prozess.bip_bescheibung_abh_log is
    'Beschreibung der wsentlichen Abhängikeit  der Logisitk';

comment on column am_main.hwas_betriebsinterner_prozess.bip_bezeichnung is
    'eindeutige Bezeichnung des Prozesses';

comment on column am_main.hwas_betriebsinterner_prozess.bip_uid is
    'Primärschlüssel';

comment on column am_main.hwas_betriebsinterner_prozess.bip_zusammenfassung is
    'Zusammenfassung des Prozesses';

comment on column am_main.hwas_betriebsinterner_prozess.inserted is
    'Insert Datum';

comment on column am_main.hwas_betriebsinterner_prozess.inserted_by is
    'Insert User';

comment on column am_main.hwas_betriebsinterner_prozess.updated is
    'Update Datum';

comment on column am_main.hwas_betriebsinterner_prozess.updated_by is
    'Update User';

