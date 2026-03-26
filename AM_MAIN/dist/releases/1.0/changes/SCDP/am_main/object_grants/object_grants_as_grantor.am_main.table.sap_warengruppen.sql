-- liquibase formatted sql
-- changeset AM_MAIN:1774556568224 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_warengruppen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_warengruppen.sql:null:76737c5661b2d4ee5c908980145278ebb0ff077c:create

grant select on am_main.sap_warengruppen to am_apex;

grant read on am_main.sap_warengruppen to am_apex;

