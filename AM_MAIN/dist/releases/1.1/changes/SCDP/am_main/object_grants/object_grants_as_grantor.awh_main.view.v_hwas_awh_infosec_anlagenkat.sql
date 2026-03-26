-- liquibase formatted sql
-- changeset AM_MAIN:1774557122362 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_anlagenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_anlagenkat.sql:null:68731d298472be7e625005feecfb230ce665ac58:create

grant select on awh_main.v_hwas_awh_infosec_anlagenkat to am_main;

grant references on awh_main.v_hwas_awh_infosec_anlagenkat to am_main;

