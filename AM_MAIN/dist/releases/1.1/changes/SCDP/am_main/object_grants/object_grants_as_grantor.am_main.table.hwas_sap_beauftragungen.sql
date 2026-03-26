-- liquibase formatted sql
-- changeset AM_MAIN:1774557116002 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_sap_beauftragungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_sap_beauftragungen.sql:null:026bbda64db4ce6a67ff5b78cde5f3ab1eb2c049:create

grant select on am_main.hwas_sap_beauftragungen to am_apex;

