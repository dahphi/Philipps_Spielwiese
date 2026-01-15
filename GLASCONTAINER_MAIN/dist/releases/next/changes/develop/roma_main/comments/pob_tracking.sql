-- liquibase formatted sql
-- changeset roma_main:1768480976842 stripComments:false logicalFilePath:develop/roma_main/comments/pob_tracking.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/pob_tracking.sql:null:a2d19e76f056e753f2617cd714b1bd9321ab00a6:create

comment on table roma_main.pob_tracking is
    '@ticket FTTH-4003: Speichert bestimmte Seitenzugriffe im Glascontainer (anonymisiert)';

comment on column roma_main.pob_tracking.app_id is
    'APEX-Anwendungsnummer im Workspace (aktueller Wert von :APP_ID)';

comment on column roma_main.pob_tracking.app_page_id is
    'APEX-Seitennumer (aktueller Wert von :APP_PAGE_ID)';

comment on column roma_main.pob_tracking.app_session is
    'APEX-Session-ID (aktueller Wert von :APP_SESSION)';

comment on column roma_main.pob_tracking.datum is
    'Erfassung des Klicks: Datum/Uhrzeit (Default SYSDATE). Für die effiziente Auswertung existiert ein Function Based Index auf TRUNC(DATUM).'
    ;

comment on column roma_main.pob_tracking.extra is
    '(Spalte kann gedroppt werden, sobald der Algorithmus getestet wurde) Der Inhalt des Arguments piv_extra in PCK_GLASCONTAINER.track_page, wird vom Algorithmus aufgelöst und in die Tabelle POB_TRACKING_EXTRA eingetragen'
    ;

comment on column roma_main.pob_tracking.id is
    'Technischer PK (IDENTITY)';

comment on column roma_main.pob_tracking.request is
    'Submit-Aktion (aktueller Wert von :REQUEST)';

comment on column roma_main.pob_tracking.scope is
    'Optionale nummerische Information, in welchem Teil einer Aufgabe der Klick registiert wurde (derzeit: Wizard-Steps 0...6 in der Bestellerfassung)'
    ;

comment on column roma_main.pob_tracking.task is
    'Nummerische Klammer, ähnlich einem Scoope, mit der zusammenhängende Klicks markiert werden. Datenquelle: POB_TASK_SEQ. Beispiel: Eine Bestellung im Glascontainer hat bis zu ihrem Abschluss stets die gleiche Task-Nummer.'
    ;

