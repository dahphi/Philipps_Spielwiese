-- liquibase formatted sql
-- changeset AM_MAIN:1774556568051 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_leitlinie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_leitlinie.sql:null:bad9c8017d0cf160858bba07f8c1fa5a825fa604:create

grant select on am_main.hwas_leitlinie to am_apex;

