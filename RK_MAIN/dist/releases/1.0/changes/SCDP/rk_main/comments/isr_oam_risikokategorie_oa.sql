-- liquibase formatted sql
-- changeset rk_main:1774554916442 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_risikokategorie_oa.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_risikokategorie_oa.sql:null:208f67a8727774a9ec26d60200aed31371e03915:create

comment on column rk_main.isr_oam_risikokategorie_oa.aktiv is
    'kann verwendet werden';

comment on column rk_main.isr_oam_risikokategorie_oa.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_risikokategorie_oa.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_risikokategorie_oa.rkt_beschschreibung is
    'Beschreibung der Risikoketegorie';

comment on column rk_main.isr_oam_risikokategorie_oa.rkt_titel is
    'Bezeichnungder Risikokategorie';

comment on column rk_main.isr_oam_risikokategorie_oa.rkt_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_risikokategorie_oa.updated is
    'Update Datum';

comment on column rk_main.isr_oam_risikokategorie_oa.updated_by is
    'Update User';

