-- liquibase formatted sql
-- changeset AM_MAIN:1774556568280 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_virtuelle_maschinen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_virtuelle_maschinen.sql:null:20ec88656883dcba221c0cd3376fd24c4839bc0f:create

grant select on am_main.v_awh_hwas_virtuelle_maschinen to awh_apex;

grant select on am_main.v_awh_hwas_virtuelle_maschinen to awh_main;

