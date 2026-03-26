-- liquibase formatted sql
-- changeset RK_MAIN:1774561789328 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_elem_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_elem_gefaehrdung.sql:d26fcafb8d11ba036d44d2facbda74a9d83a70cf:3739d7b1c9d74839e06f542f0a7e29eabd842e15:alter

grant select on rk_main.isr_brm_elem_gefaehrdung to rk_apex;

