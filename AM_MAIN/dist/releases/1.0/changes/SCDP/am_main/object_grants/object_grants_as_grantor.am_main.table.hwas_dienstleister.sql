-- liquibase formatted sql
-- changeset AM_MAIN:1774556567912 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_dienstleister.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_dienstleister.sql:null:4216cb846fe0b4770db3a3f8d401469d2c73f34c:create

grant select on am_main.hwas_dienstleister to am_apex;

grant select on am_main.hwas_dienstleister to rk_apex;

grant read on am_main.hwas_dienstleister to rk_apex;

