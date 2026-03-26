-- liquibase formatted sql
-- changeset AM_MAIN:1774556568215 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_kostenstellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.sap_kostenstellen.sql:null:40f8277cb606d4cdeb395536d647e6cff27f4884:create

grant select on am_main.sap_kostenstellen to am_apex;

