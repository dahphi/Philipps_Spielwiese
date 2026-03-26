-- liquibase formatted sql
-- changeset AM_MAIN:1774557122459 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.table.params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.params.sql:null:0d3a56e43bd11fa7593811e8722339e82ad384d7:create

grant read on core.params to am_main;

