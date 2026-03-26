-- liquibase formatted sql
-- changeset AM_MAIN:1774556574181 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.table.awh_tab_verantwortungstyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.table.awh_tab_verantwortungstyp.sql:null:42c7aa9cde5b0cde6755388c930916bfc5129413:create

grant select on awh_main.awh_tab_verantwortungstyp to am_main;

