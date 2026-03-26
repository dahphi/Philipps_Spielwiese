-- liquibase formatted sql
-- changeset RK_MAIN:1774554915819 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.view.v_assets.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_assets.sql:null:a69d87d2baa46917edd6d5ed66be4fb3c03c8fd3:create

grant select on am_main.v_assets to rk_main;

