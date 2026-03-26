-- liquibase formatted sql
-- changeset AM_MAIN:1774557115731 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_warengruppe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_warengruppe.sql:null:6032a75bd76440aea787b3ea8d3ab45f52946ce7:create

grant execute on am_main.pck_hwas_warengruppe to am_apex;

