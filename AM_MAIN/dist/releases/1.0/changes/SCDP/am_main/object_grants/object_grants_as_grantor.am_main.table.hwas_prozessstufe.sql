-- liquibase formatted sql
-- changeset AM_MAIN:1774556568104 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozessstufe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozessstufe.sql:null:8fc3d37fce5e5c18e3baa8b33a07fce1d41bf1cc:create

grant select on am_main.hwas_prozessstufe to am_apex;

grant select on am_main.hwas_prozessstufe to awh_apex;

grant read on am_main.hwas_prozessstufe to awh_read_jira;

