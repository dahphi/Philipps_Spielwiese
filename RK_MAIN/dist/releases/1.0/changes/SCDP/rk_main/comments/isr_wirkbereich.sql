-- liquibase formatted sql
-- changeset rk_main:1774561690358 stripComments:false logicalFilePath:SCDP/rk_main/comments/isr_wirkbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/isr_wirkbereich.sql:null:f31c52ba9bcb96630bfca7f863de7f53767e8138:create

comment on column rk_main.isr_wirkbereich.i2a_uids is
    'Fremdschlüsselliste ISO 27001 Anahang A Controls';

comment on column rk_main.isr_wirkbereich.inserted is
    'Insert Datum';

comment on column rk_main.isr_wirkbereich.inserted_by is
    'Insert User';

comment on column rk_main.isr_wirkbereich.updated is
    'Update Datum';

comment on column rk_main.isr_wirkbereich.updated_by is
    'Update User';

comment on column rk_main.isr_wirkbereich.wbi_informed is
    'Rollen/Geschäftbereiche informiert';

comment on column rk_main.isr_wirkbereich.wbr_accountable is
    'Rollen/Geschäftbereiche kfm. verantwortlich';

comment on column rk_main.isr_wirkbereich.wbr_bezeichnung is
    'Bezeichung des Wirkbereichs';

comment on column rk_main.isr_wirkbereich.wbr_consulted is
    'Rollen/Geschäftbereiche beratend';

comment on column rk_main.isr_wirkbereich.wbr_responsible is
    'Rollen/Geschäftbereiche verantwortlich';

comment on column rk_main.isr_wirkbereich.wbr_supportive is
    'Rollen/Geschäftbereiche unterstützend';

comment on column rk_main.isr_wirkbereich.wbr_uid is
    'Primärschlüssel';

