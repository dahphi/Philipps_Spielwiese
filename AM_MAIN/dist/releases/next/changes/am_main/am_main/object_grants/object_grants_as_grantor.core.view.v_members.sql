-- liquibase formatted sql
-- changeset AM_MAIN:1774600129710 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.core.view.v_members.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_members.sql:null:7f9f04a0067a7fd0c815e3551dc24af546ce7d34:create

grant select on core.v_members to am_main;

