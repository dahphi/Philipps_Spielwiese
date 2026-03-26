-- liquibase formatted sql
-- changeset AM_MAIN:1774556568076 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produkt.sql:null:5297f326b8c346725e309056c0fe8248bb2ccffb:create

grant select on am_main.hwas_produkt to am_apex;

grant select on am_main.hwas_produkt to awh_apex;

