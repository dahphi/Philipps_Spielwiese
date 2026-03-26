-- liquibase formatted sql
-- changeset AM_MAIN:1774556574276 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.package_spec.pck_env.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.package_spec.pck_env.sql:null:8eb04b7e3d219fe36fa9b0da298c0ac9c820de88:create

grant execute on core.pck_env to am_main;

