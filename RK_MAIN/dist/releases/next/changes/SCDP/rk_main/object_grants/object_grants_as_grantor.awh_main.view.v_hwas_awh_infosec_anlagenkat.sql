-- liquibase formatted sql
-- changeset RK_MAIN:1774561689681 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_anlagenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_infosec_anlagenkat.sql:null:9689dcc01c923090fb864b54a932e0d106e72f17:create

grant select on awh_main.v_hwas_awh_infosec_anlagenkat to rk_main;

grant references on awh_main.v_hwas_awh_infosec_anlagenkat to rk_main;

