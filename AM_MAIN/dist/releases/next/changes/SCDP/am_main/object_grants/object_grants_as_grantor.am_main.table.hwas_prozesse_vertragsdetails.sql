-- liquibase formatted sql
-- changeset AM_MAIN:1774557115970 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozesse_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_prozesse_vertragsdetails.sql:null:024c5cb7e812083248050bf1ebbd37cc3ce41338:create

grant select on am_main.hwas_prozesse_vertragsdetails to am_apex;

