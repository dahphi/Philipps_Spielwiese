-- liquibase formatted sql
-- changeset AM_MAIN:1774556568151 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag_titel.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertrag_titel.sql:null:15683a1590b72846ce7d7637a6fe22fc7067984d:create

grant select on am_main.hwas_vertrag_titel to am_apex;

grant read on am_main.hwas_vertrag_titel to awh_apex;

