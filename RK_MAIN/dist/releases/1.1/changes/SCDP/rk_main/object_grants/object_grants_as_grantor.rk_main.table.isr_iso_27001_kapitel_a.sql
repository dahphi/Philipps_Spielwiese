-- liquibase formatted sql
-- changeset RK_MAIN:1774555709193 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_kapitel_a.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_iso_27001_kapitel_a.sql:null:1a14872e5e013d037b99052401fb9d796d08545c:create

grant select on rk_main.isr_iso_27001_kapitel_a to rk_apex;

