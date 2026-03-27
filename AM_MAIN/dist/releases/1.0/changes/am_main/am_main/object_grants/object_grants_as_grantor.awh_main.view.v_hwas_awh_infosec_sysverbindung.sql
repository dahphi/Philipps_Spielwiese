-- liquibase formatted sql
-- changeset AM_MAIN:1774600129312 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_sysverbindung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_sysverbindung.sql:null:bf061987c85381fb2a890b33b482064d600c99c2:create

grant select on awh_main.v_hwas_awh_infosec_sysverbindung to am_main;

grant references on awh_main.v_hwas_awh_infosec_sysverbindung to am_main;

