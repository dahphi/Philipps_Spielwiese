-- liquibase formatted sql
-- changeset AM_MAIN:1774557115758 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_beauftragungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_beauftragungen.sql:null:64f66d445781df14c6c8eb941c94a14d8acafb19:create

grant select on am_main.hwas_beauftragungen to am_apex;

grant select on am_main.hwas_beauftragungen to rk_apex;

grant read on am_main.hwas_beauftragungen to rk_apex;

