-- liquibase formatted sql
-- changeset RK_MAIN:1774561789334 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdungkat.sql:6b77ce3a5adc8af7566b7b12e3dc7bdcdac62c6a:759b3e6c38e84c5890012672764e72b3df05963e:alter

grant select on rk_main.isr_brm_gefaehrdungkat to rk_apex;

