-- liquibase formatted sql
-- changeset RK_MAIN:1774561789414 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_parameter.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_parameter.sql:e40646f74743a2e32800aafb53f05ac41f9c0f0a:48a35769bff645da3e4f1b806eb95cd07ed77094:alter

grant select on rk_main.isr_parameter to rk_apex;

