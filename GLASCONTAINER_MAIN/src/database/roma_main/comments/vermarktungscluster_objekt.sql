comment on table roma_main.vermarktungscluster_objekt is
    'Zuordnungen von Objekten (HAUS_LFD_NR) zu Vermarktungsclustern (VC_LFD_NR) , wobei jedes Objekt maximal einmal zugeordnet werden kann'
    ;

comment on column roma_main.vermarktungscluster_objekt.eigentuemerdaten_notwendig is
    'NULL=Default (bei Vermarktungsclustern, die nicht Wholebuy sind, ist dieser Wert nicht definiert), 1=Eigentümerdaten sind notwendig, 0=Eigentümerdaten sind nicht notwendig. Datenquelle: Tabellen TCOM_ADR_BSA und DG_ADR_BSA, @ticket FTTH-3169'
    ;

comment on column roma_main.vermarktungscluster_objekt.haus_lfd_nr is
    'Objekt, welches genau einem Vermarktungscluster zugeordnet ist';

comment on column roma_main.vermarktungscluster_objekt.inserted is
    'Insert Datum';

comment on column roma_main.vermarktungscluster_objekt.inserted_by is
    'Insert User';

comment on column roma_main.vermarktungscluster_objekt.updated is
    'Update Datum';

comment on column roma_main.vermarktungscluster_objekt.updated_by is
    'Update User';

comment on column roma_main.vermarktungscluster_objekt.vco_lfd_nr is
    'PK (technischer Primärschlüssel)';

comment on column roma_main.vermarktungscluster_objekt.vc_lfd_nr is
    'Neue Spalte ab 2024-07, @ticket FTTH-3169: NULL=Default (bei Vermarktungsclustern, die nicht Wholebuy sind, ist diese Information nicht definiert), 1=Eigentümerdaten sind notwendig, 0=Eigentümerdaten sind nicht notwendig. Datenquelle: Tabellen TCOM_ADR_BSA und DG_ADR_BSA'
    ;


-- sqlcl_snapshot {"hash":"82be2c016ea2bc3af5335d7317923f737fc56c4c","type":"COMMENT","name":"vermarktungscluster_objekt","schemaName":"roma_main","sxml":""}