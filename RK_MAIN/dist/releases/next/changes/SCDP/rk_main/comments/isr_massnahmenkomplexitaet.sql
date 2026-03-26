-- liquibase formatted sql
-- changeset rk_main:1774554916267 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_massnahmenkomplexitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_massnahmenkomplexitaet.sql:null:e491cb94bb49a311411c6731f77f4d09d6947e29:create

comment on column rk_main.isr_massnahmenkomplexitaet.inserted is
    'Insert Datum';

comment on column rk_main.isr_massnahmenkomplexitaet.inserted_by is
    'Insert User';

comment on column rk_main.isr_massnahmenkomplexitaet.mkp_beschreibung is
    'Beschreibung';

comment on column rk_main.isr_massnahmenkomplexitaet.mkp_bezeichnung is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_massnahmenkomplexitaet.mkp_uid is
    'Primärschlüssel';

comment on column rk_main.isr_massnahmenkomplexitaet.updated is
    'Update Datum';

comment on column rk_main.isr_massnahmenkomplexitaet.updated_by is
    'Update User';

