-- liquibase formatted sql
-- changeset RK_MAIN:1774554915801 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_raum.sql:null:dda37d1d25021d608cd73eea169075051d66396a:create

grant read on am_main.hwas_raum to rk_main;

