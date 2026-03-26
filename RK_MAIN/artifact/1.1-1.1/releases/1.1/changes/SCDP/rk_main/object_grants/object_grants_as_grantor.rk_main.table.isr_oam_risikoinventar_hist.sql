-- liquibase formatted sql
-- changeset RK_MAIN:1774555709271 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoinventar_hist.sql:null:c640f5342e026691fcccd0085a3298f48c9e7bd1:create

grant read on rk_main.isr_oam_risikoinventar_hist to rk_apex;

