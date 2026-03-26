-- liquibase formatted sql
-- changeset RK_MAIN:1774554915946 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.package_spec.pck_logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.package_spec.pck_logs.sql:null:44d1dc7a6a2c1120dbb31544211f4f04497fe5d9:create

grant execute on core.pck_logs to rk_main;

