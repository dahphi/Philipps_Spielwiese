comment on table roma_main.vermarktungscluster is
    'Vermarktungscluster';

comment on column roma_main.vermarktungscluster.anlage_typ is
    'Wie wurde das Vermarktungscliuster angelegt (MANUELL, AUTOMATISCH)';

comment on column roma_main.vermarktungscluster.inserted is
    'Insert Datum';

comment on column roma_main.vermarktungscluster.inserted_by is
    'Insert User';

comment on column roma_main.vermarktungscluster.kosten_hausanschluss is
    '@TICKET FTTH-47: Kosten des Hausanschlusses fuer Eigentuemer (Euro-Betrag, Nachkommastellen erlaubt). Default: 0';

comment on column roma_main.vermarktungscluster.kundenauftrag_erforderlich is
    '@TICKET FTTH-47: Ist fuer einen Hausanschluss zusaetzlich mindestens ein Kundenauftrag erforderlich (1=Ja|0=Nein). Default: Ja';

comment on column roma_main.vermarktungscluster.loeschgrund is
    '@ticket FTTH-2323: Grund, der beim Löschen eines Vermarktungsclusters angegeben werden muss: 1 = Projekt fertiggestellt 2 = Projekt zurückgezogen 3 = Test'
    ;

comment on column roma_main.vermarktungscluster.mandant is
    'NC|NA für NetCologne bzw. NetAachen. Wert wird beim Anlegen des Vermarktungsclusters entweder manuell eingetragen oder (wenn es sich um ein Wholebuy-Cluster handelt) aus Datenquellen abgeleitet, derzeit (Stand 2024-06, @ticket FTTH-3169) sind das die Tabellen TCOM_ADR_BSA und DG_ADR_BSA'
    ;

comment on column roma_main.vermarktungscluster.mindestbandbreite is
    '@TICKET FTTH-47: Bandbreite, die in dem jeweiligen Vermarktungscluster mindestens bestellt werden muss (in Mbit/s). Default: 250'
    ;

comment on column roma_main.vermarktungscluster.netwissen_seite is
    '@TICKET FTTH-47: ID (oder URL) der Netwissen-Seite zu diesem Vermarktungscluster. Default: https://netwelt.netcologne.intern/x/brL6Cw'
    ;

comment on column roma_main.vermarktungscluster.updated is
    'Update Datum';

comment on column roma_main.vermarktungscluster.updated_by is
    'Update User';

comment on column roma_main.vermarktungscluster.url is
    'Internet-Landingpage für Privatkunden';

comment on column roma_main.vermarktungscluster.url_gk is
    '@ticket FTTH-2190: Internet-Landingpage für Geschäftskunden';

comment on column roma_main.vermarktungscluster.vc_lfd_nr is
    'PK';

comment on column roma_main.vermarktungscluster.wholebuy is
    '2023-11-02 @ticket FTTH-2901: ENUM-Wert für Wholebuy-Partner. Stand 2023-11: NULL oder TELEKOM';

comment on column roma_main.vermarktungscluster.zielbandbreite_geplant is
    '@TICKET FTTH-47: Geplante Zielbandbreite im Vermarktungscluster (in Mbit/s). Default: 1000';


-- sqlcl_snapshot {"hash":"c9641d14a4e6f8ac68a9d34a8fa546090743f51e","type":"COMMENT","name":"vermarktungscluster","schemaName":"roma_main","sxml":""}