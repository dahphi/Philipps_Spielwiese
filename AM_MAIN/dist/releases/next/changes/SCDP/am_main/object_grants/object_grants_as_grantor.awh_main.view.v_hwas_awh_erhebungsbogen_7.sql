-- liquibase formatted sql
-- changeset AM_MAIN:1774556574190 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erhebungsbogen_7.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erhebungsbogen_7.sql:null:897cf32fd656621115d51b3f43aefed759af6d1c:create

grant select on awh_main.v_hwas_awh_erhebungsbogen_7 to am_main;

grant references on awh_main.v_hwas_awh_erhebungsbogen_7 to am_main;

