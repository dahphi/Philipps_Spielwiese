-- liquibase formatted sql
-- changeset roma_main:1768480976826 stripComments:false logicalFilePath:develop/roma_main/comments/pob_adressen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/pob_adressen.sql:null:a92ba4baeeb1fc2967b9f21e0c38ce3e30075f8d:create

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

