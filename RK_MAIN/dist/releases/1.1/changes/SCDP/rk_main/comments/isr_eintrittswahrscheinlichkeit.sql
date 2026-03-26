-- liquibase formatted sql
-- changeset rk_main:1774555708675 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_eintrittswahrscheinlichkeit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_eintrittswahrscheinlichkeit.sql:null:e54c785c0828625b3a8f6e93f79eaac35e3cfe13:create

comment on column rk_main.isr_eintrittswahrscheinlichkeit.ews_bezeichnung is
    'Bezeichnung';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.ews_kriterien is
    'Kriterien für die Einordnung von Ereignissen';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.ews_prozentsatz is
    'Prozentsatz der Eintrittswahrscheinlichkeit';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.ews_uid is
    'Primärschlüssel';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.ews_wert is
    'Wert der Eintrittswahrscheinlichkeit für Berechnungen';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.inserted is
    'Insert Datum';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.inserted_by is
    'Insert User';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.updated is
    'Update Datum';

comment on column rk_main.isr_eintrittswahrscheinlichkeit.updated_by is
    'Update User';

