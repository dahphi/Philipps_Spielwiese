-- liquibase formatted sql
-- changeset RK_MAIN:1774554915823 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.awh_main.table.awh_tab_infosec_sys_status.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/awh_main/object_grants/object_grants_as_grantor.awh_main.table.awh_tab_infosec_sys_status.sql:null:87b338fcc4b0ef96bb1ce4c6e596786bbd78cf85:create

grant read on awh_main.awh_tab_infosec_sys_status to rk_main;

