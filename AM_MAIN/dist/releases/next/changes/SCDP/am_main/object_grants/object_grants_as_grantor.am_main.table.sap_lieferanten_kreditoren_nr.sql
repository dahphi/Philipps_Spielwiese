-- liquibase formatted sql
-- changeset AM_MAIN:1774557116091 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_lieferanten_kreditoren_nr.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_lieferanten_kreditoren_nr.sql:null:630bf88cfaf8500ceff95a5cd2951fb7da38f95a:create

grant select on am_main.sap_lieferanten_kreditoren_nr to am_apex;

