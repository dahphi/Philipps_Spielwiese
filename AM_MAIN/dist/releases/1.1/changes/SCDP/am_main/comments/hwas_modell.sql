-- liquibase formatted sql
-- changeset am_main:1774557115429 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_modell.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_modell.sql:null:f6199f53864832ddd3fc335fba866e1339d84b2e:create

comment on column am_main.hwas_modell.fkl_uid is
    'Fremdschlüssel funktionsklasse';

comment on column am_main.hwas_modell.gkl_uid is
    'Fremdschlüssel Geräteklasse (OUDATED)
';

comment on column am_main.hwas_modell.hst_uid is
    'Fremdschlüssel Hersteller';

comment on column am_main.hwas_modell.inserted is
    'Insert Datum';

comment on column am_main.hwas_modell.inserted_by is
    'Insert User';

comment on column am_main.hwas_modell.mdl_anzahl_systeme is
    'Anzahl der eingesetztren/vorhandenen Systeme des Modells(?)';

comment on column am_main.hwas_modell.mdl_bezeichnung is
    'Modell-Bezeichnung';

comment on column am_main.hwas_modell.mdl_grund_tn_je_system is
    'Begündung des Verhältnisses Teinehmer je System';

comment on column am_main.hwas_modell.mdl_regel is
    'Regel (zur Verteilung von Teilnehmern auf Systeme?)';

comment on column am_main.hwas_modell.mdl_tn_je_system is
    'Teinehmer je System';

comment on column am_main.hwas_modell.mdl_uid is
    'Primärschlüssel';

comment on column am_main.hwas_modell.updated is
    'Update Datum';

comment on column am_main.hwas_modell.updated_by is
    'Update User';

