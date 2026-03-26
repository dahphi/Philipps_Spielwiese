-- liquibase formatted sql
-- changeset AM_MAIN:1774556567883 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_bean_funktionsklassen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_bean_funktionsklassen.sql:null:bbdd4ca0a9f0ba33be2c750ee0315228192f66d1:create

grant select on am_main.hwas_bean_funktionsklassen to am_apex;

grant select on am_main.hwas_bean_funktionsklassen to rk_apex;

grant read on am_main.hwas_bean_funktionsklassen to rk_apex;

