-- liquibase formatted sql
-- changeset rk_main:1774561690218 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_massnahmenkontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_massnahmenkontext.sql:null:20ced9115150203cb06f2abf8720b0cc8e918490:create

comment on column rk_main.isr_oam_massnahmenkontext.aktiv is
    'Status ob Maßnahmenkontext aktiv ist oder nicht';

comment on column rk_main.isr_oam_massnahmenkontext.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_massnahmenkontext.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_massnahmenkontext.mkt_beschreibung is
    'Beschreibung';

comment on column rk_main.isr_oam_massnahmenkontext.mkt_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_massnahmenkontext.updated is
    'Update Datum';

comment on column rk_main.isr_oam_massnahmenkontext.updated_by is
    'Update User';

