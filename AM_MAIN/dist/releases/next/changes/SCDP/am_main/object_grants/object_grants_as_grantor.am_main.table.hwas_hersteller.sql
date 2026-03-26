-- liquibase formatted sql
-- changeset AM_MAIN:1774557115875 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_hersteller.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_hersteller.sql:null:c86d53204247a54beb5d5043cf5e8e96a900cdaf:create

grant select on am_main.hwas_hersteller to am_apex;

grant select on am_main.hwas_hersteller to rk_apex;

grant read on am_main.hwas_hersteller to rk_main;

grant read on am_main.hwas_hersteller to rk_apex;

