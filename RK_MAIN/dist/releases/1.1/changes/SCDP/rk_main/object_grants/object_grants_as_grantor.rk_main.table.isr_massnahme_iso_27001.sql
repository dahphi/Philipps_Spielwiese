-- liquibase formatted sql
-- changeset RK_MAIN:1774561789357 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_iso_27001.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_iso_27001.sql:8986bbf5676a98981a6fc95e65f81d90aea0ffc3:5e891741ba888afdf1da1132526d7ba3da366e3f:alter

grant select on rk_main.isr_massnahme_iso_27001 to rk_apex;

