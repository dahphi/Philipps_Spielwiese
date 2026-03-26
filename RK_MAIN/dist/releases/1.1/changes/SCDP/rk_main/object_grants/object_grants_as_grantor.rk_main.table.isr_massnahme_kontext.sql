-- liquibase formatted sql
-- changeset RK_MAIN:1774561789361 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_kontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_massnahme_kontext.sql:03c534016d9e2a54774308c651065e78980cf353:db18cc9cd7933854166b44cf964a699dcc323b3d:alter

grant select on rk_main.isr_massnahme_kontext to rk_apex;

grant select on rk_main.isr_massnahme_kontext to awh_apex;

