-- liquibase formatted sql
-- changeset RK_MAIN:1774561689810 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.table.params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.params.sql:null:bcd04cb29b113bb9fa95ecca34bab1fd0c916442:create

grant read on core.params to rk_main;

