-- liquibase formatted sql
-- changeset RK_MAIN:1774555708320 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erhebungsbogen_7.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_erhebungsbogen_7.sql:null:5e2a0a09df15176d8a22b9a249ba6f8062813d87:create

grant select on awh_main.v_hwas_awh_erhebungsbogen_7 to rk_main;

grant references on awh_main.v_hwas_awh_erhebungsbogen_7 to rk_main;

