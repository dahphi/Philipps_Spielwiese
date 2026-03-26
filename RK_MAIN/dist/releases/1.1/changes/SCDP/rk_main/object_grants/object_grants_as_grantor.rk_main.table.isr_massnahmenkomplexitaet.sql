-- liquibase formatted sql
-- changeset RK_MAIN:1774561789366 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahmenkomplexitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahmenkomplexitaet.sql:97d6314b8c8831cb3531b69fedf3696440dde4e6:0f0397f35fbf86c0ec560cb610649ab8b1928edf:alter

grant select on rk_main.isr_massnahmenkomplexitaet to rk_apex;

