-- liquibase formatted sql
-- changeset RK_MAIN:1774555709198 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_iso_27001.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_iso_27001.sql:null:5e891741ba888afdf1da1132526d7ba3da366e3f:create

grant select on rk_main.isr_massnahme_iso_27001 to rk_apex;

grant read on rk_main.isr_massnahme_iso_27001 to rk_read;

