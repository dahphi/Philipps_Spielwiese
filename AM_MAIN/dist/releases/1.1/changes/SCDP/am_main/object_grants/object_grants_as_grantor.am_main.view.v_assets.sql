-- liquibase formatted sql
-- changeset AM_MAIN:1774557116106 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_assets.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_assets.sql:null:8e42f1c711182b9c5942a909f5b08c683679d4ca:create

grant select on am_main.v_assets to rk_apex;

grant select on am_main.v_assets to am_apex;

grant select on am_main.v_assets to rk_main;

