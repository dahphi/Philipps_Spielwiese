-- liquibase formatted sql
-- changeset rk_main:1774555708804 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_oam_massnahmenkatalog.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_oam_massnahmenkatalog.sql:null:34956fce41d8e355dbf71856b3b0f34bb6e1901f:create

comment on column rk_main.isr_oam_massnahmenkatalog.inserted is
    'Insert Datum';

comment on column rk_main.isr_oam_massnahmenkatalog.inserted_by is
    'Insert User';

comment on column rk_main.isr_oam_massnahmenkatalog.mnk_uid is
    'Primärschlüssel';

comment on column rk_main.isr_oam_massnahmenkatalog.msn_uid is
    'Fremdschlüssel Maßnahme';

comment on column rk_main.isr_oam_massnahmenkatalog.rsk_uid is
    'Fremdschlüssel Risiko';

comment on column rk_main.isr_oam_massnahmenkatalog.updated is
    'Update Datum';

comment on column rk_main.isr_oam_massnahmenkatalog.updated_by is
    'Update User';

