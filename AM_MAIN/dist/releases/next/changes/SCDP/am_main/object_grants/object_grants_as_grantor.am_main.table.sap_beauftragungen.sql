-- liquibase formatted sql
-- changeset AM_MAIN:1774556568212 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_beauftragungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_beauftragungen.sql:null:90adc71fe99bf77a41d26ffd7afe4868cdd39a96:create

grant select on am_main.sap_beauftragungen to am_apex;

