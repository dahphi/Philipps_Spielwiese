-- liquibase formatted sql
-- changeset RK_MAIN:1774555709295 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_parameter.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_parameter.sql:null:48a35769bff645da3e4f1b806eb95cd07ed77094:create

grant select on rk_main.isr_parameter to rk_apex;

grant read on rk_main.isr_parameter to rk_read;

