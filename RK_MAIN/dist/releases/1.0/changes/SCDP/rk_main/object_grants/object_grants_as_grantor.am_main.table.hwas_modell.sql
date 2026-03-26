-- liquibase formatted sql
-- changeset RK_MAIN:1774554915794 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_modell.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_modell.sql:null:2cff962218f645990c3e76f17c5daae90c61b0fd:create

grant read on am_main.hwas_modell to rk_main;

