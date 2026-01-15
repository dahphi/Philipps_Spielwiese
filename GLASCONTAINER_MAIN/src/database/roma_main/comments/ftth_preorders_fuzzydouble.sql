comment on table ftth_preorders_fuzzydouble is
    'Gepufferte Abfrageergebnisse des Fuzzy!Double-Services über Daten des FTTH-Preorderbuffers, um in Reports die Wahrscheinlichkeit von Dubletten anzeigen zu können, sowie beabsichtigte Dubletten zu markieren. Ein Preorder-Datensatz hat typischerweise mehrere dieser Fuzzy-Detaildatensätze.'
    ;

comment on column ftth_preorders_fuzzydouble.errorcode is
    'Falls der Score auf eine Exception gelaufen ist, wird hier der Fehlercode hinterlegt';

comment on column ftth_preorders_fuzzydouble.errortext is
    'Falls der Score auf eine Exception gelaufen ist, wird hier der Fehlertext hinterlegt';

comment on column ftth_preorders_fuzzydouble.ftth_id is
    'Referenz zum Preorder-Buffer (FK auf FTTH_WS_SYNC_PREORDERS)';

comment on column ftth_preorders_fuzzydouble.fuzzy_rowid is
    'ROWID aus der XML-Antwort des Fuzzy!Double-Servers für einen bestimmten Datensatz, oder NULL wenn keine Antwort gegeben wurde';

comment on column ftth_preorders_fuzzydouble.id is
    'Technischer PK (IDENTITY)';

comment on column ftth_preorders_fuzzydouble.score is
    'Gesamter Score-Wert für diesen Datensatz (Maximum = 100), oder NULL wenn kein Fuzzy-Suchergebnis vorliegt';

comment on column ftth_preorders_fuzzydouble.score_datum is
    'Datum/Uhrzeit, wann der Fuzzy!Double-Server dieses Ergebnis geliefert hat';

comment on column ftth_preorders_fuzzydouble.score_typ is
    'Kürzel für den Abfragetyp (PHO=PhoneticSearch, BNK=DoubletCheckBank)';

comment on column ftth_preorders_fuzzydouble.status is
    'Üblicherweise leer. Für beabsichtigte Dubletten: IGN=ignorieren';


-- sqlcl_snapshot {"hash":"e4cf0cc1b1b8b480204795cc20d8367849785db8","type":"COMMENT","name":"ftth_preorders_fuzzydouble","schemaName":"roma_main","sxml":""}