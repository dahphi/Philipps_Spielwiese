-- liquibase formatted sql
-- changeset RK_MAIN:1774561690672 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog.sql:null:134e6c7e8ebe9ca9ea75637eade3d85f9e2bf9bb:create

grant read on rk_main.isr_oam_massnahmenkatalog to awh_read_jira;

grant select on rk_main.isr_oam_massnahmenkatalog to rk_apex;

grant read on rk_main.isr_oam_massnahmenkatalog to rk_read;

grant select on rk_main.isr_oam_massnahmenkatalog to awh_apex;

