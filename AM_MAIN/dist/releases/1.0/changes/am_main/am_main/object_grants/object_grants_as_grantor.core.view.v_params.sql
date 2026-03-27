-- liquibase formatted sql
-- changeset AM_MAIN:1774600129726 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.core.view.v_params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_params.sql:null:dfc83eadad1f9c7a36c589e238783f20254ac2c6:create

grant select on core.v_params to am_main;

