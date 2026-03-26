-- liquibase formatted sql
-- changeset rk_main:1774561689940 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_assettypen_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_assettypen_gefaehrdungkat.sql:null:cabb6cce365232331342f781e18c6e7203a73aaa:create

comment on column rk_main.isr_assettypen_gefaehrdungkat.ast_uid is
    'Fremdschlüssel Assettypen';

comment on column rk_main.isr_assettypen_gefaehrdungkat.atgk_uid is
    'Primärschlüssel';

comment on column rk_main.isr_assettypen_gefaehrdungkat.gfk_uid is
    'Fremdschlüssel Gefaehrdungkat';

comment on column rk_main.isr_assettypen_gefaehrdungkat.inserted is
    'Insert Datum';

comment on column rk_main.isr_assettypen_gefaehrdungkat.inserted_by is
    'Insert User';

comment on column rk_main.isr_assettypen_gefaehrdungkat.updated is
    'Update Datum';

comment on column rk_main.isr_assettypen_gefaehrdungkat.updated_by is
    'Update User';

