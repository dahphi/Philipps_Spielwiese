-- liquibase formatted sql
-- changeset RK_MAIN:1774555708360 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_geschaeftskrit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.view.v_hwas_awh_tab_geschaeftskrit.sql:null:e165b3ee40e3ec1fad108b8e5e6995662d068bc4:create

grant select on awh_main.v_hwas_awh_tab_geschaeftskrit to rk_main;

grant references on awh_main.v_hwas_awh_tab_geschaeftskrit to rk_main;

