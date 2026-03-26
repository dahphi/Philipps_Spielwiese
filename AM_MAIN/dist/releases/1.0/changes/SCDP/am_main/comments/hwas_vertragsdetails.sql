-- liquibase formatted sql
-- changeset am_main:1774556567686 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_vertragsdetails.sql:null:b9035e4e48edbf19d33f378ab32eb030f33bc7ec:create

comment on column am_main.hwas_vertragsdetails.prod_bes_uid_fk is
    'Produktbestandteil vom Produkt';

comment on column am_main.hwas_vertragsdetails.ver_ti_uid_fk is
    'Titel vom Vertrag';

