comment on table roma_main.pob_adressen is
    '@ticket FTTH-4625: Persistierung der im Preorderbuffer benötigten Adressen, da ein LEFT JOIN mit V_ADRESSEN die Auftrags-Reports im Glascontainer um den Faktor 50 langsamer macht. Die Aktualisierung erfolgt jeweils mit einem Aufruf des Auftrags sowie bei der nächtlichen Synchronisierung mit dem Backend.'
    ;

comment on column roma_main.pob_adressen.ausbaugebiete is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Ausbaugebieten, denen diese Adresse zugeordnet ist.'
    ;

comment on column roma_main.pob_adressen.ausbaugebietstypen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Ausbaugebietstypen, denen diese Adresse zugeordnet ist.'
    ;

comment on column roma_main.pob_adressen.erschliessungen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Erschließungsständen, denen diese Adresse zugeordnet ist.'
    ;

comment on column roma_main.pob_adressen.projekte is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Projekten, denen diese Adresse zugeordnet ist.'
    ;

comment on column roma_main.pob_adressen.projektnamen is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Projektnamen, denen diese Adresse zugeordnet ist.'
    ;

comment on column roma_main.pob_adressen.status_ausbaugebiet is
    '@ticket FTTH-4273: Persistierte, ggf. konkatenierte Informationen zu einem oder mehreren Status von Ausbaugebieten, denen diese Adresse zugeordnet ist.'
    ;


-- sqlcl_snapshot {"hash":"1a1ca4770ca0b5e687b3d8a31f829f2288e74614","type":"COMMENT","name":"pob_adressen","schemaName":"roma_main","sxml":""}