-- liquibase formatted sql
-- changeset RK_MAIN:1774555709158 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_brm_gefaehrdungkat.sql:null:759b3e6c38e84c5890012672764e72b3df05963e:create

grant select on rk_main.isr_brm_gefaehrdungkat to rk_apex;

grant read on rk_main.isr_brm_gefaehrdungkat to rk_read;

