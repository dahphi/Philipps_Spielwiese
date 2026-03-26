-- liquibase formatted sql
-- changeset RK_MAIN:1774554916743 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_auswirkung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_auswirkung.sql:null:e43b15a686eed069528332ebd51d526b6cfa7489:create

grant select on rk_main.isr_auswirkung to rk_apex;

grant read on rk_main.isr_auswirkung to rk_read;

