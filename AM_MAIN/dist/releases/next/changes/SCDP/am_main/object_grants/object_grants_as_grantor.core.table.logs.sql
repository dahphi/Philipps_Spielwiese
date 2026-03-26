-- liquibase formatted sql
-- changeset AM_MAIN:1774557122444 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.table.logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.logs.sql:null:a9f125e649f1f0a68d26ce3e0dd900d47c45a1ba:create

grant select on core.logs to am_main;

grant read on core.logs to am_main;

