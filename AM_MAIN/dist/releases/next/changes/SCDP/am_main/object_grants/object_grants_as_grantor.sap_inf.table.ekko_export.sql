-- liquibase formatted sql
-- changeset AM_MAIN:1774556574318 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.sap_inf.table.ekko_export.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/sap_inf/object_grants/object_grants_as_grantor.sap_inf.table.ekko_export.sql:null:c3443fb5d32be5f2ba69265d6609904e8e8a0d24:create

grant read on sap_inf.ekko_export to am_main;

