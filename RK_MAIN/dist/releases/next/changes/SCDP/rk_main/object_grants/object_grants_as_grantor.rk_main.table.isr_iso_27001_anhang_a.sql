-- liquibase formatted sql
-- changeset RK_MAIN:1774561789347 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_anhang_a.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_anhang_a.sql:f56472a4904cd6ae25632bdaf807deb587ae4cc4:6394b69ed059142d23708a8be0e5aa53436d8160:alter

grant select on rk_main.isr_iso_27001_anhang_a to rk_apex;

