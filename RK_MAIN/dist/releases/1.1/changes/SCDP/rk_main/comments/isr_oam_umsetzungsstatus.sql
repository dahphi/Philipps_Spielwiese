-- liquibase formatted sql
-- changeset rk_main:1774555708922 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_umsetzungsstatus.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_umsetzungsstatus.sql:null:108fb00fec1180bd3aa80a1d009ea7f7e08f0c42:create

comment on column rk_main.isr_oam_umsetzungsstatus.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_umsetzungsstatus.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_umsetzungsstatus.updated is
    'Update Datum';

comment on column rk_main.isr_oam_umsetzungsstatus.updated_by is
    'Update User';

comment on column rk_main.isr_oam_umsetzungsstatus.uss_beschreibung is
    'Beschreibungstext';

comment on column rk_main.isr_oam_umsetzungsstatus.uss_bezeichnung is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_oam_umsetzungsstatus.uss_uid is
    'Primärschlüssel';

