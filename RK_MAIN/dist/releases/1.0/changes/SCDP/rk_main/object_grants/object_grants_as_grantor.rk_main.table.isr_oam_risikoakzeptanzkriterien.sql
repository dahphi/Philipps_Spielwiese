-- liquibase formatted sql
-- changeset RK_MAIN:1774561690689 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoakzeptanzkriterien.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoakzeptanzkriterien.sql:null:2d71005e52f11bbf66cd3685ae3078a214e4d9b3:create

grant select on rk_main.isr_oam_risikoakzeptanzkriterien to rk_apex;

grant read on rk_main.isr_oam_risikoakzeptanzkriterien to rk_read;

