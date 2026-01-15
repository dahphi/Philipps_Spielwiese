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


-- sqlcl_snapshot {"hash":"cb14c97c4386764b3c371d841fd6f6e308aed627","type":"COMMENT","name":"pob_tracking","schemaName":"roma_main","sxml":""}