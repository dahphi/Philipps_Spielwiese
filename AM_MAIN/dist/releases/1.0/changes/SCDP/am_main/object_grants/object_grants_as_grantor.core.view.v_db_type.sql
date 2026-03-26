-- liquibase formatted sql
-- changeset AM_MAIN:1774556574307 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.view.v_db_type.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_db_type.sql:null:53871e0164c05560c152eb55d50f24904443ccc6:create

grant select on core.v_db_type to am_main;

