-- liquibase formatted sql
-- changeset RK_MAIN:1774561789390 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoakzeptanzkriterien.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikoakzeptanzkriterien.sql:a84bd98951be54f50e4fc66d7f6b9bb7f8adc9e7:2d71005e52f11bbf66cd3685ae3078a214e4d9b3:alter

grant select on rk_main.isr_oam_risikoakzeptanzkriterien to rk_apex;

