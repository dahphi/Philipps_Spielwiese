-- liquibase formatted sql
-- changeset RK_MAIN:1774554916899 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql:null:98c32e087781261f48e055286c0436e689381722:create

grant select on rk_main.isr_oam_risikoinventar to rk_apex;

grant select on rk_main.isr_oam_risikoinventar to awh_apex;

grant read on rk_main.isr_oam_risikoinventar to awh_read_jira;

grant read on rk_main.isr_oam_risikoinventar to rk_read;

