-- liquibase formatted sql
-- changeset rk_main:1774554916377 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_risikoakzeptanzkriterien.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_risikoakzeptanzkriterien.sql:null:ca63acb9932a10c7e257c83631a9d499e0f2f8a8:create

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.rak_beschreibung is
    'Beschreibung des Kriteriums';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.rak_bezeichnung is
    'Beszeichnung des Kriteriums';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.rak_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.rak_wert is
    'Bewertung des Kriteriums für Berechnungen
';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.updated is
    'Update Datum';

comment on column rk_main.isr_oam_risikoakzeptanzkriterien.updated_by is
    'Update User';

