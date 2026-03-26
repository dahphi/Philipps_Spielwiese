-- liquibase formatted sql
-- changeset AM_MAIN:1774556574278 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.package_spec.pck_logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.package_spec.pck_logs.sql:null:bb7df1f102e38f24e5d04a4fb7f41a26e9da3121:create

grant execute on core.pck_logs to am_main;

