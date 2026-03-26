-- liquibase formatted sql
-- changeset RK_MAIN:1774561789331 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdung.sql:0e475ed9c67c12ddfbbbb2733a71f581e5778eb3:8176befc9ca01dafb237ecf6784345f76c0b1951:alter

grant select on rk_main.isr_brm_gefaehrdung to rk_apex;

