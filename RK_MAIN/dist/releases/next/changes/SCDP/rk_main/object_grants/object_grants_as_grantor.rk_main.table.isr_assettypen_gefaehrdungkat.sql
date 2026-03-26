-- liquibase formatted sql
-- changeset RK_MAIN:1774561789321 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettypen_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettypen_gefaehrdungkat.sql:b663e2068b583cb264b61a3009ca56738cf7355e:ec6ebd8246b1fb1627759609cc49c46a08ecd680:alter

grant select on rk_main.isr_assettypen_gefaehrdungkat to rk_apex;

