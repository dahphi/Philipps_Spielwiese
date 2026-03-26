-- liquibase formatted sql
-- changeset RK_MAIN:1774554915784 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteverbund.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteverbund.sql:null:77a7ab3e7331985d8e3900c75d37602421e89c12:create

grant read on am_main.hwas_geraeteverbund to rk_main;

