comment on table pob_adressen is
    '@ticket FTTH-4625: Persistierung der im Preorderbuffer benötigten Adressen, da ein LEFT JOIN mit V_ADRESSEN die Auftrags-Reports im Glascontainer um den Faktor 50 langsamer macht. Die Aktualisierung erfolgt jeweils mit einem Aufruf des Auftrags sowie bei der nächtlichen Synchronisierung mit dem Backend.'
    ;

comment on column pob_adressen.ausbaugebiete is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Ausbaugebieten, denen diese Adresse zugeordnet ist.'
    ;

comment on column pob_adressen.ausbaugebietstypen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Ausbaugebietstypen, denen diese Adresse zugeordnet ist.'
    ;

comment on column pob_adressen.erschliessungen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Erschließungsständen, denen diese Adresse zugeordnet ist.'
    ;

comment on column pob_adressen.projekte is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Projekten, denen diese Adresse zugeordnet ist.'
    ;

comment on column pob_adressen.projektnamen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Projektnamen, denen diese Adresse zugeordnet ist.'
    ;

comment on column pob_adressen.status_ausbaugebiet is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Status von Ausbaugebieten, denen diese Adresse zugeordnet ist.'
    ;


-- sqlcl_snapshot {"hash":"f7db2dbc8c8f005c9fb0cd522d35f6273ed8a1af","type":"COMMENT","name":"pob_adressen","schemaName":"roma_main","sxml":""}