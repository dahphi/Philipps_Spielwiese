-- liquibase formatted sql
-- changeset RK_MAIN:1774555708406 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.package_spec.ad.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.package_spec.ad.sql:null:c8540279264ba1bb8ddfb83999942f42053815b3:create

grant execute on core.ad to rk_main;

