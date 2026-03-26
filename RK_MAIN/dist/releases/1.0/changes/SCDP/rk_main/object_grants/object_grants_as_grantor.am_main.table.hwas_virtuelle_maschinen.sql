-- liquibase formatted sql
-- changeset RK_MAIN:1774561689650 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_virtuelle_maschinen.sql:null:c5238f283a26f7187ffbd92f462230d7b32cc8d6:create

grant read on am_main.hwas_virtuelle_maschinen to rk_main;

