-- liquibase formatted sql
-- changeset rk_main:1774561690342 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_parameter.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_parameter.sql:null:d2a1d94d0f4319aabead6c0fa646c08174279b7b:create

comment on column rk_main.isr_parameter.inserted is
    'Insert Datum';

comment on column rk_main.isr_parameter.inserted_by is
    'Insert User';

comment on column rk_main.isr_parameter.par_bezeichnung is
    'eindeutige Bezichnung';

comment on column rk_main.isr_parameter.par_string_value is
    'Wert des Parameters as Zeichenfolge, Typumwandlung ist Sache der Anwendung!';

comment on column rk_main.isr_parameter.par_uid is
    'Primärschlüssel';

comment on column rk_main.isr_parameter.updated is
    'Update Datum';

comment on column rk_main.isr_parameter.updated_by is
    'Update User';

