-- liquibase formatted sql
-- changeset am_main:1774556567464 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_geraeteverbund.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_geraeteverbund.sql:null:b656c8f224974a66a92be615e52ed27787531279:create

comment on column am_main.hwas_geraeteverbund.gvb_bezeichnung is
    'Bezeichnung des Geräteverbunds';

comment on column am_main.hwas_geraeteverbund.gvb_san is
    'Verantwortlicher Data Custodian (AD SAN)';

comment on column am_main.hwas_geraeteverbund.gvb_uid is
    'Primärschlüssel';

comment on column am_main.hwas_geraeteverbund.gvb_verbundtyp is
    'Typ von Geräten, aus denen sich der Verbund sortenrein zusammensetzen muss';

comment on column am_main.hwas_geraeteverbund.inserted is
    'Insert Datum';

comment on column am_main.hwas_geraeteverbund.inserted_by is
    'Insert User';

comment on column am_main.hwas_geraeteverbund.typ_uid is
    '"Fremdschllüssel" auf den bestimmenden Mitgliedstyp (derzeit Modell oder Funktionsklasse)';

comment on column am_main.hwas_geraeteverbund.updated is
    'Update Datum';

comment on column am_main.hwas_geraeteverbund.updated_by is
    'Update User';

