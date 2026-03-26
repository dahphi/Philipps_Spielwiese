-- liquibase formatted sql
-- changeset AM_MAIN:1774556574293 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.table.logs_ext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.logs_ext.sql:null:e0d255aaeadea5b28be90a6f7cb712b21166b25a:create

grant select on core.logs_ext to am_main;

grant read on core.logs_ext to am_main;

