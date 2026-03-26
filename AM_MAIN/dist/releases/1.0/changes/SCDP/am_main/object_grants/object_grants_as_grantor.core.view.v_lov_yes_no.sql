-- liquibase formatted sql
-- changeset AM_MAIN:1774556574309 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.core.view.v_lov_yes_no.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_lov_yes_no.sql:null:0db1af04da1dbdf9104dc8a686a8ea04577dafc0:create

grant select on core.v_lov_yes_no to am_main;

