-- liquibase formatted sql
-- changeset RK_MAIN:1774561789401 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikokategorie_oa.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikokategorie_oa.sql:56c09ae0333725030472ee9d531fc321d4d961dd:8f0fae057cd6cb91f3c1d09c7d5696b13d7fc697:alter

grant select on rk_main.isr_oam_risikokategorie_oa to rk_apex;

