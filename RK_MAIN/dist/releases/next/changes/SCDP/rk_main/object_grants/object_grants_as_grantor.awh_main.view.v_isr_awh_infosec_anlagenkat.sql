-- liquibase formatted sql
-- changeset RK_MAIN:1774561689764 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_infosec_anlagenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_isr_awh_infosec_anlagenkat.sql:null:7cdd76a4f3852b77d30284752c2088cf56139130:create

grant read on awh_main.v_isr_awh_infosec_anlagenkat to rk_main;

