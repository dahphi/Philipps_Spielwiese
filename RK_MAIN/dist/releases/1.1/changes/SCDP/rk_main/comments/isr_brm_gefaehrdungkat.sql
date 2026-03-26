-- liquibase formatted sql
-- changeset rk_main:1774555708631 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_brm_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_brm_gefaehrdungkat.sql:null:d1a3c37dc7662816e5bc08956f9ac9ba55e6caa1:create

comment on column rk_main.isr_brm_gefaehrdungkat.gfk_name is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_brm_gefaehrdungkat.gfk_uid is
    'Primärschlüssel';

comment on column rk_main.isr_brm_gefaehrdungkat.inserted is
    'Insert Datum';

comment on column rk_main.isr_brm_gefaehrdungkat.inserted_by is
    'Insert User';

comment on column rk_main.isr_brm_gefaehrdungkat.updated is
    'Update Datum';

comment on column rk_main.isr_brm_gefaehrdungkat.updated_by is
    'Update User';

