-- liquibase formatted sql
-- changeset RK_MAIN:1774554915973 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.view.v_db_type.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_db_type.sql:null:3d566fd63d68f22fea14d6cb5a70a427c815a7f9:create

grant select on core.v_db_type to rk_main;

