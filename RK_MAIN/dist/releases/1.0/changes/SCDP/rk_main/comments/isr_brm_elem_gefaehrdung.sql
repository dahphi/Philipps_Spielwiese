-- liquibase formatted sql
-- changeset rk_main:1774554916128 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_brm_elem_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_brm_elem_gefaehrdung.sql:null:9118898244bb546e6658ebd22592306a9c51415d:create

comment on column rk_main.isr_brm_elem_gefaehrdung.aktiv is
    'kann verwendet werden';

comment on column rk_main.isr_brm_elem_gefaehrdung.ege_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_brm_elem_gefaehrdung.ege_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_brm_elem_gefaehrdung.ege_uid is
    'Primärschlüssel';

comment on column rk_main.isr_brm_elem_gefaehrdung.inserted is
    'Insert Datum';

comment on column rk_main.isr_brm_elem_gefaehrdung.inserted_by is
    'Insert User';

comment on column rk_main.isr_brm_elem_gefaehrdung.updated is
    'Update Datum';

comment on column rk_main.isr_brm_elem_gefaehrdung.updated_by is
    'Update User';

