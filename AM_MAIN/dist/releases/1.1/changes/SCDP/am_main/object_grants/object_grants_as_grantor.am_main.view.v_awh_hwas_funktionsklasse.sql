-- liquibase formatted sql
-- changeset AM_MAIN:1774557116125 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_funktionsklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_funktionsklasse.sql:null:17ea62df37da704d5104caeb8fd462a8535d8051:create

grant select on am_main.v_awh_hwas_funktionsklasse to awh_apex;

grant select on am_main.v_awh_hwas_funktionsklasse to awh_main;

