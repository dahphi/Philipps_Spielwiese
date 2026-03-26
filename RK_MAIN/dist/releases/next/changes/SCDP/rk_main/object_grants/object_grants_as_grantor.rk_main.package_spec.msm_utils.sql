-- liquibase formatted sql
-- changeset RK_MAIN:1774561690400 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.package_spec.msm_utils.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.package_spec.msm_utils.sql:null:20eaa4643f358c642583a9e93e49764a2e719ee3:create

grant execute on rk_main.msm_utils to rk_apex;

