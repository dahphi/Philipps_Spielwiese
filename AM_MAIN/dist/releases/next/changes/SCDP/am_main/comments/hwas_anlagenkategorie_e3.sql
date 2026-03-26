-- liquibase formatted sql
-- changeset am_main:1774557115111 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_anlagenkategorie_e3.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_anlagenkategorie_e3.sql:null:6407ac93b5dd441e84ee57ba2dd265ca37375068:create

comment on column am_main.hwas_anlagenkategorie_e3.ak3_bemessungskriterium is
    'Bezeichnung des KRITIS-Bemessungskriteriums inkl. Einheit des Schwellwerts';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_beschreibung is
    'Beschreibung der Anlagenkategorie';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_dataenquelle_vg is
    'Datenquelle für den Versorgungsgrad';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_definition is
    'Definition der Anlagenkategorie';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_nc_bezeichnung is
    'bei NetCologne für die Anlangenkategorie verwendete Kurzbecheinung';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_nc_implementierung is
    'Interpretation der BSI-Anlagenkategorie bei NC';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_nummer is
    'Nummer Ebene 3 der Dezimalklassifikation';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_schwellenwert_ueberschritten is
    'ermittelter Versorgungsgrad überschreitet Schwellenwert';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_schwellwert is
    'Schwellwert für das Bemessungskriterium';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_uid is
    'Primärschlüssel';

comment on column am_main.hwas_anlagenkategorie_e3.ak3_versorgungsgrad is
    'ermittelter Versorgungsgrad';

comment on column am_main.hwas_anlagenkategorie_e3.be2_uid is
    'Fremdschlüssel KritisV-Bereich';

comment on column am_main.hwas_anlagenkategorie_e3.inserted is
    'Insert Datum';

comment on column am_main.hwas_anlagenkategorie_e3.inserted_by is
    'Insert User';

comment on column am_main.hwas_anlagenkategorie_e3.updated is
    'Update Datum';

comment on column am_main.hwas_anlagenkategorie_e3.updated_by is
    'Update User';

