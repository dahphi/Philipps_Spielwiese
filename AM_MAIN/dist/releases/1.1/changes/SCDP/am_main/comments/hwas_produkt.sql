-- liquibase formatted sql
-- changeset am_main:1774557115491 stripComments:false logicalFilePath:SCDP/am_main/comments/hwas_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/hwas_produkt.sql:null:e207d0d4c54d412a9115f6de8abaa32cacd10121:create

comment on column am_main.hwas_produkt.gesku_uid_fk is
    'Geschäftskunden FK';

comment on column am_main.hwas_produkt.prom_uid_fk is
    'FK zu den Promotions';

comment on column am_main.hwas_produkt.tech_ansprechpartner is
    'Technischer Ansprechpartner';

