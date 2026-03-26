-- liquibase formatted sql
-- changeset AM_MAIN:1774556568004 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geschaeftskunden.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geschaeftskunden.sql:null:198fb477952f3eb73d3bb6a7f50ad12916166374:create

grant select on am_main.hwas_geschaeftskunden to am_apex;

grant select on am_main.hwas_geschaeftskunden to awh_apex;

grant select on am_main.hwas_geschaeftskunden to awh_read_jira;

