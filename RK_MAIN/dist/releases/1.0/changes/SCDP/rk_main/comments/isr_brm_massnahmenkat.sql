-- liquibase formatted sql
-- changeset rk_main:1774554916180 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_brm_massnahmenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_brm_massnahmenkat.sql:null:2a7b49d02db3920ba8ddbe050f0197ca2ffa571b:create

comment on column rk_main.isr_brm_massnahmenkat.inserted is
    'Insert Datum';

comment on column rk_main.isr_brm_massnahmenkat.inserted_by is
    'Insert User';

comment on column rk_main.isr_brm_massnahmenkat.mka_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_brm_massnahmenkat.mka_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_brm_massnahmenkat.mka_uid is
    'Primärschlüssel';

comment on column rk_main.isr_brm_massnahmenkat.updated is
    'Update Datum';

comment on column rk_main.isr_brm_massnahmenkat.updated_by is
    'Update User';

