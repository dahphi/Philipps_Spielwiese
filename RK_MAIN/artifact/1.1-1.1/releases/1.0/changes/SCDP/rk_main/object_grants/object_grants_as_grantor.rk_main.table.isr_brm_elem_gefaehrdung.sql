-- liquibase formatted sql
-- changeset RK_MAIN:1774554916750 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_elem_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_elem_gefaehrdung.sql:null:3739d7b1c9d74839e06f542f0a7e29eabd842e15:create

grant select on rk_main.isr_brm_elem_gefaehrdung to rk_apex;

grant read on rk_main.isr_brm_elem_gefaehrdung to rk_read;

