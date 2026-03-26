-- liquibase formatted sql
-- changeset RK_MAIN:1774561789325 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_auswirkung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_auswirkung.sql:e13a42e9a8f297c8c02321288c5ea7f4816d4812:e43b15a686eed069528332ebd51d526b6cfa7489:alter

grant select on rk_main.isr_auswirkung to rk_apex;

