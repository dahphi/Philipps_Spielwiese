-- liquibase formatted sql
-- changeset AM_MAIN:1774600099930 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_rufbereitschaft.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.package_spec.pck_hwas_rufbereitschaft.sql:null:8bbbda143ce3c92fb6ebb38638773243fbe465fa:create

grant execute on am_main.pck_hwas_rufbereitschaft to am_apex;

