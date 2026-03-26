-- liquibase formatted sql
-- changeset RK_MAIN:1774561690667 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahme_hist.sql:null:4c8ec5714d87ae18c77d03b01744b821b6dc7950:create

grant select on rk_main.isr_oam_massnahme_hist to rk_apex;

