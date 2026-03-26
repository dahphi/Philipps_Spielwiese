-- liquibase formatted sql
-- changeset RK_MAIN:1774561789394 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql:6a257bfaeb5b55e6d64119c40bb624fca1dea38a:98c32e087781261f48e055286c0436e689381722:alter

grant select on rk_main.isr_oam_risikoinventar to rk_apex;

grant select on rk_main.isr_oam_risikoinventar to awh_apex;

grant select on rk_main.isr_oam_risikoinventar to am_apex;

