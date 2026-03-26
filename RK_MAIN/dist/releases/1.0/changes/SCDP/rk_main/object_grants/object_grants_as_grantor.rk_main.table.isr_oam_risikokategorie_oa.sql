-- liquibase formatted sql
-- changeset RK_MAIN:1774554916911 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikokategorie_oa.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikokategorie_oa.sql:null:8f0fae057cd6cb91f3c1d09c7d5696b13d7fc697:create

grant select on rk_main.isr_oam_risikokategorie_oa to rk_apex;

grant read on rk_main.isr_oam_risikokategorie_oa to rk_read;

