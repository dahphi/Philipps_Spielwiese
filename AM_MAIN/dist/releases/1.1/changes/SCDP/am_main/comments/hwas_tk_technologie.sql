-- liquibase formatted sql
-- changeset am_main:1774557115522 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_tk_technologie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_tk_technologie.sql:null:95691e782c8a7744a06cc51385078c63f1ef5bf3:create

comment on column am_main.hwas_tk_technologie.ak3_uid is
    'Fremdschlüssel Anlagenkategorie';

comment on column am_main.hwas_tk_technologie.bip_uid is
    'Fremdschlüssel Betriebsinterner Prozess';

comment on column am_main.hwas_tk_technologie.inserted is
    'Insert Datum';

comment on column am_main.hwas_tk_technologie.inserted_by is
    'Insert User';

comment on column am_main.hwas_tk_technologie.krk_uid is
    'Fremdschlüssel Kritikalität';

comment on column am_main.hwas_tk_technologie.tkt_bezeichnung is
    'TK-Technologie-Bezeichnung';

comment on column am_main.hwas_tk_technologie.tkt_highlights is
    'TK-Technologie Highlights';

comment on column am_main.hwas_tk_technologie.tkt_lebenszyklus_status is
    'geplant, aktiv,auslaufend oder obsolet';

comment on column am_main.hwas_tk_technologie.tkt_uid is
    'Primärschlüssel';

comment on column am_main.hwas_tk_technologie.updated is
    'Update Datum';

comment on column am_main.hwas_tk_technologie.updated_by is
    'Update User';

