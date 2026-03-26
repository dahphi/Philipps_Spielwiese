-- liquibase formatted sql
-- changeset RK_MAIN:1774561690625 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_mapping.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_mapping.sql:null:22fa4b039160f1b8d02ce3c43ed4e2569380cc4a:create

grant select on rk_main.isr_iso_27001_mapping to rk_apex;

