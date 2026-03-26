-- liquibase formatted sql
-- changeset RK_MAIN:1774561690695 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar.sql:null:5fbb79b9e055cb91266724e97a529fbb784868e3:create

grant read on rk_main.isr_oam_risikoinventar to awh_read_jira;

grant select on rk_main.isr_oam_risikoinventar to rk_apex;

grant read on rk_main.isr_oam_risikoinventar to rk_read;

grant select on rk_main.isr_oam_risikoinventar to awh_apex;

