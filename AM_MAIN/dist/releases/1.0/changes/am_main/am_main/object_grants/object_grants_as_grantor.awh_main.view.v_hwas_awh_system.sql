-- liquibase formatted sql
-- changeset AM_MAIN:1774600129406 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_system.sql:null:616f557d153c7fe0c85e734f02c17525f90eea6d:create

grant select on awh_main.v_hwas_awh_system to am_main;

grant references on awh_main.v_hwas_awh_system to am_main;

