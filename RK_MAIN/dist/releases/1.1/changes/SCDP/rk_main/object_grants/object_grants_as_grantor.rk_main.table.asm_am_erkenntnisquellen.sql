-- liquibase formatted sql
-- changeset RK_MAIN:1774555709097 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_erkenntnisquellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_erkenntnisquellen.sql:null:df4f331958f23f11a971f098c326c2e16578e195:create

grant select on rk_main.asm_am_erkenntnisquellen to rk_apex;

grant read on rk_main.asm_am_erkenntnisquellen to rk_read;

