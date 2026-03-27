-- liquibase formatted sql
-- changeset AM_MAIN:1774600099989 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.bsi_grundschutzbausteine.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.bsi_grundschutzbausteine.sql:null:3f4a67aaa0370c68e8529e797648def360324c51:create

grant select on am_main.bsi_grundschutzbausteine to am_apex;

