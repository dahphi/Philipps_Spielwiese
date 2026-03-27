-- liquibase formatted sql
-- changeset am_main:1774600099476 stripComments:false logicalFilePath:am_main/am_main/comments/sap_warengruppen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/sap_warengruppen.sql:null:35e691c069d8e69897d282b5408678b18662ef26:create

comment on column am_main.sap_warengruppen.is_relevant is
    'Ja Nein Feld ob Relevant in der Informationssicherheit';

comment on column am_main.sap_warengruppen.sap_id is
    'SAP Interne ID';

comment on column am_main.sap_warengruppen.war_uid is
    'GUID PK';

