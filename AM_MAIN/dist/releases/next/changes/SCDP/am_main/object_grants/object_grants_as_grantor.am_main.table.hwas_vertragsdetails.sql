-- liquibase formatted sql
-- changeset AM_MAIN:1774556568156 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_vertragsdetails.sql:null:a64315a91e6045568197e3e1c4749aa965957ab6:create

grant select on am_main.hwas_vertragsdetails to am_apex;

grant select on am_main.hwas_vertragsdetails to awh_apex;

