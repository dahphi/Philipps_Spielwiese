-- liquibase formatted sql
-- changeset RK_MAIN:1774555708452 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.view.v_params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_params.sql:null:21b0d36b9595870f09df0fd5ab133028d989d04f:create

grant select on core.v_params to rk_main;

