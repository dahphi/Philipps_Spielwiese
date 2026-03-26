-- liquibase formatted sql
-- changeset RK_MAIN:1774561689629 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_gebaeude.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_gebaeude.sql:null:59e6bd76c5fe2baba9fd4292f0d3cae09eb7bfeb:create

grant read on am_main.hwas_gebaeude to rk_main;

