-- liquibase formatted sql
-- changeset am_main:1774557115236 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_gebaeude.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_gebaeude.sql:null:c3fbbe7ca06fb4965c95e6c307c22fb87ab58d88:create

comment on column am_main.hwas_gebaeude.data_custodian is
    'SAMACCOUNTNAME';

comment on column am_main.hwas_gebaeude.geb_adresszusatz is
    'Adresszusatz des Gebäudes';

comment on column am_main.hwas_gebaeude.geb_bezeichnung is
    'Gebäudebezeichnung';

comment on column am_main.hwas_gebaeude.geb_kritis_relevant is
    'originär kritis-relevant wg. kritis-relevantem Housing/Rechenzentrum; 1=ja, 0=nein';

comment on column am_main.hwas_gebaeude.geb_ort is
    'Ort des Gebäudes';

comment on column am_main.hwas_gebaeude.geb_plz is
    'Postleitzahl des Gebäudes';

comment on column am_main.hwas_gebaeude.geb_strasse_hnr is
    'Straße und Hausnummer des Gebäudes';

comment on column am_main.hwas_gebaeude.geb_uid is
    'Primärschlüssel';

comment on column am_main.hwas_gebaeude.inserted is
    'Insert Datum';

comment on column am_main.hwas_gebaeude.inserted_by is
    'Insert User';

comment on column am_main.hwas_gebaeude.obj_id is
    'Fremdschlüssel zur Site';

comment on column am_main.hwas_gebaeude.site is
    'Fremdschlüssel ITWO_SITE';

comment on column am_main.hwas_gebaeude.updated is
    'Update Datum';

comment on column am_main.hwas_gebaeude.updated_by is
    'Update User';

