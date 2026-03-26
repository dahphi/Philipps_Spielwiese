-- liquibase formatted sql
-- changeset RK_MAIN:1774561690633 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_kontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_kontext.sql:null:db18cc9cd7933854166b44cf964a699dcc323b3d:create

grant select on rk_main.isr_massnahme_kontext to rk_apex;

grant read on rk_main.isr_massnahme_kontext to rk_read;

grant select on rk_main.isr_massnahme_kontext to awh_apex;

