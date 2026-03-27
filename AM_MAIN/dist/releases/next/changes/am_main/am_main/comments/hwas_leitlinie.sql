-- liquibase formatted sql
-- changeset am_main:1774600098573 stripComments:false logicalFilePath:am_main/am_main/comments/hwas_leitlinie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_leitlinie.sql:null:81689153902cca749d57062495260e3579c5e2f6:create

comment on column am_main.hwas_leitlinie.inserted is
    'Insert Datum';

comment on column am_main.hwas_leitlinie.inserted_by is
    'Insert User';

comment on column am_main.hwas_leitlinie.ll_ansprechpartner is
    'SAN des Ansprtechpartners';

comment on column am_main.hwas_leitlinie.ll_beschreibung is
    'Beschreibung der Leitlinie';

comment on column am_main.hwas_leitlinie.ll_uid is
    'Primärschlüssel';

comment on column am_main.hwas_leitlinie.updated is
    'Update Datum';

comment on column am_main.hwas_leitlinie.updated_by is
    'Update User';

