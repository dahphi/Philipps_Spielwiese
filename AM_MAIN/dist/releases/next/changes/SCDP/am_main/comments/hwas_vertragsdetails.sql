-- liquibase formatted sql
-- changeset am_main:1774557215827 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_vertragsdetails.sql:null:89eb0b89a385d56493de0363258e6ff2dbc2a0b6:create

comment on column am_main.hwas_vertragsdetails.betriebsrelevanz is
    'Ja nein Feld';

comment on column am_main.hwas_vertragsdetails.prod_bes_uid_fk is
    'Produktbestandteil vom Produkt';

comment on column am_main.hwas_vertragsdetails.ver_ti_uid_fk is
    'Titel vom Vertrag';

