-- liquibase formatted sql
-- changeset AM_MAIN:1774556568197 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_raum_import_hist.sql:null:b5b7397ad1f038814bed0866a2b99b2be164ba90:create

grant select on am_main.itwo_raum_import_hist to am_apex;

