-- liquibase formatted sql
-- changeset AM_MAIN:1774557116135 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_informationscluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.view.v_awh_hwas_informationscluster.sql:null:df2b80801cf8c9c90799d9bed635274ddd5b7e41:create

grant select on am_main.v_awh_hwas_informationscluster to awh_main;

grant select on am_main.v_awh_hwas_informationscluster to awh_apex;

