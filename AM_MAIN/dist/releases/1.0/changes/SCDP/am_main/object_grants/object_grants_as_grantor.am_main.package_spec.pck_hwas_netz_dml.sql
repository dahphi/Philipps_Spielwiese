-- liquibase formatted sql
-- changeset AM_MAIN:1774556567836 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_netz_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_netz_dml.sql:null:13fdcc17d9f2537318042653cba459186bf5e146:create

grant execute on am_main.pck_hwas_netz_dml to am_apex;

