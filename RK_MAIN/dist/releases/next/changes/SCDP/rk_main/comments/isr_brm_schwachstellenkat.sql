-- liquibase formatted sql
-- changeset rk_main:1774561690049 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_brm_schwachstellenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_brm_schwachstellenkat.sql:null:004279d74d40c41619a33af78af278390b8c41d6:create

comment on column rk_main.isr_brm_schwachstellenkat.aktiv is
    'kann verwendet werden';

comment on column rk_main.isr_brm_schwachstellenkat.inserted is
    'Insert Datum';

comment on column rk_main.isr_brm_schwachstellenkat.inserted_by is
    'Insert User';

comment on column rk_main.isr_brm_schwachstellenkat.ska_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.isr_brm_schwachstellenkat.ska_titel is
    'eindeutige Bezeichnung';

comment on column rk_main.isr_brm_schwachstellenkat.ska_uid is
    'Primärschlüssel';

comment on column rk_main.isr_brm_schwachstellenkat.updated is
    'Update Datum';

comment on column rk_main.isr_brm_schwachstellenkat.updated_by is
    'Update User';

