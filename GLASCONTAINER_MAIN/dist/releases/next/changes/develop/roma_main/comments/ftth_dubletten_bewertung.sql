-- liquibase formatted sql
-- changeset roma_main:1768480976041 stripComments:false logicalFilePath:develop/roma_main/comments/ftth_dubletten_bewertung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/ftth_dubletten_bewertung.sql:null:6990b1d36cf091f9fed8e2cd1d68ece82f9e7928:create

comment on table roma_main.ftth_dubletten_bewertung is
    'Glascontainer: Speichert die Bearbeitung der FuzzyDouble-Dublettenliste durch eine Mitarbeiter:in, indem eine Kombination von Kundennummer zu Kundennumer bewertet wird (beispielsweise als gewollte Dublette), so dass diese zukünftig nicht mehr überflüssigerweise in der Dubletten-Ergebnisliste auftaucht'
    ;

comment on column roma_main.ftth_dubletten_bewertung.aktuell is
    'Für schnelle SQL-Selektion: Wenn dies der zuletzt gespeicherte Datensatz für die Kombination aus KNR0 und KNR1 ist, dann 1, ansonsten leer.'
    ;

comment on column roma_main.ftth_dubletten_bewertung.bewertung is
    'Kategorie für die Bewertung. Stand 2023-01: G= gewollte Dublette, W= klären/Wiedervorlage, X= kein Zusammenhang';

comment on column roma_main.ftth_dubletten_bewertung.datum is
    'Wann wurde diese Bewertung angelegt';

comment on column roma_main.ftth_dubletten_bewertung.fuzzy_rowid is
    'Das ROWID-Feld der Fuzzy-Dublettenantwort (SOAP), siehe PCK_FUZZYDOUBLE. Eventuell wurde zu diesem Ergebnis keine Kundennummer (KNR1) in Siebel gefunden, dann wird (vorläufig) die Fuzzy Rowid gespeichert.'
    ;

comment on column roma_main.ftth_dubletten_bewertung.id is
    'Technischer PK (Identity)';

comment on column roma_main.ftth_dubletten_bewertung.knr0 is
    'Kundennummer, mit der in Fuzzy gesucht wurde';

comment on column roma_main.ftth_dubletten_bewertung.knr1 is
    'Kundennummer des Fuzzy-Ergebnisses';

comment on column roma_main.ftth_dubletten_bewertung.kommentar is
    'Optionaler Bearbeitungsvermerk zu dieser Bewertung';

comment on column roma_main.ftth_dubletten_bewertung.username is
    'APEX-Benutzer:in, die diesen Datensatz angelegt hat';

