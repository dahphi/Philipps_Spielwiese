-- liquibase formatted sql
-- changeset AM_MAIN:1774557116115 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_bereich_e2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_bereich_e2.sql:null:475fe3717324845e00c69345b85669948b94124c:create

grant select on am_main.v_awh_hwas_bereich_e2 to awh_apex;

grant select on am_main.v_awh_hwas_bereich_e2 to awh_main;

