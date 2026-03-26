-- liquibase formatted sql
-- changeset AM_MAIN:1774557116088 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_lieferanten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_lieferanten.sql:null:b27d700d3532dda10e555b21765f19c1f222162c:create

grant select on am_main.sap_lieferanten to am_apex;

