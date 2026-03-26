-- liquibase formatted sql
-- changeset AM_MAIN:1774556567988 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteklasse.sql:null:8cf2e533837d697cf690f2462702ad5f370aedfe:create

grant select on am_main.hwas_geraeteklasse to am_apex;

