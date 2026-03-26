-- liquibase formatted sql
-- changeset rk_main:1774561689917 stripComments:false logicalFilePath:SCDP/rk_main/comments/asm_isr_assets_risiken.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/asm_isr_assets_risiken.sql:null:7ab8530add87fccf242452f71aec544c42f6d7a5:create

comment on column rk_main.asm_isr_assets_risiken.asri_uid is
    'Primärschlüssel';

comment on column rk_main.asm_isr_assets_risiken.ass_uid is
    'Fremdschlüssel Assets';

comment on column rk_main.asm_isr_assets_risiken.inserted is
    'Insert Datum';

comment on column rk_main.asm_isr_assets_risiken.inserted_by is
    'Insert User';

comment on column rk_main.asm_isr_assets_risiken.rsk_uid is
    'Fremschlüssel Risiko';

comment on column rk_main.asm_isr_assets_risiken.updated is
    'Update Datum';

comment on column rk_main.asm_isr_assets_risiken.updated_by is
    'Update User';

