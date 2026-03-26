-- liquibase formatted sql
-- changeset AM_MAIN:1774556574270 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.package_spec.ad.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.package_spec.ad.sql:null:bfe7fda30aaf2ca0bb5cb8f141cf14bfb052ec91:create

grant execute on core.ad to am_main;

