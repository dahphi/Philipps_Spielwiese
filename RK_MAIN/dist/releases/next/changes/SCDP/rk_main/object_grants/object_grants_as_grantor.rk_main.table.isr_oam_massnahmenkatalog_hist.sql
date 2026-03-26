-- liquibase formatted sql
-- changeset RK_MAIN:1774555709248 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_massnahmenkatalog_hist.sql:null:d9516b6f96f32686f9b41fdaab6c6432d4ff6931:create

grant select on rk_main.isr_oam_massnahmenkatalog_hist to rk_apex;

