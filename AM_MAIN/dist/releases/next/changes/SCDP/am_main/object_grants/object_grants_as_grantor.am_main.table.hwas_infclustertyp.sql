-- liquibase formatted sql
-- changeset AM_MAIN:1774556568020 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_infclustertyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_infclustertyp.sql:null:1bdcc4219e37ae1ebd3987e8b4d418234daa0cc4:create

grant select on am_main.hwas_infclustertyp to am_apex;

grant select on am_main.hwas_infclustertyp to awh_apex;

