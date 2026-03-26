-- liquibase formatted sql
-- changeset AM_MAIN:1774556568085 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produktlinie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_produktlinie.sql:null:23f70f34c80f0d17a7e188178f9c4e83b04b5f0d:create

grant select on am_main.hwas_produktlinie to am_apex;

