-- liquibase formatted sql
-- changeset am_main:1774556567444 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_geraeteklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_geraeteklasse.sql:null:1d4d1bc99397511890f88a2f352a56b981876788:create

comment on column am_main.hwas_geraeteklasse.gkl_art is
    'Netelement/Netzabschluss';

comment on column am_main.hwas_geraeteklasse.gkl_bezeichnung is
    'Gerätegattung-Bezeichnung';

comment on column am_main.hwas_geraeteklasse.gkl_highlights is
    'Gerätegattung Highlights';

comment on column am_main.hwas_geraeteklasse.gkl_uid is
    'Primärschlüssel';

comment on column am_main.hwas_geraeteklasse.inserted is
    'Insert Datum';

comment on column am_main.hwas_geraeteklasse.inserted_by is
    'Insert User';

comment on column am_main.hwas_geraeteklasse.tkt_uid is
    'Fremdschlüssel TK-Technologie';

comment on column am_main.hwas_geraeteklasse.updated is
    'Update Datum';

comment on column am_main.hwas_geraeteklasse.updated_by is
    'Update User';

