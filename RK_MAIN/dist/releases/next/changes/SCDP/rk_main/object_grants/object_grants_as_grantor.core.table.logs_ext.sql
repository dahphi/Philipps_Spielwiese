-- liquibase formatted sql
-- changeset RK_MAIN:1774561689805 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.table.logs_ext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.table.logs_ext.sql:null:8a9b2b3a17c3f16ecb25751522485ad52d9ea18c:create

grant select on core.logs_ext to rk_main;

grant read on core.logs_ext to rk_main;

