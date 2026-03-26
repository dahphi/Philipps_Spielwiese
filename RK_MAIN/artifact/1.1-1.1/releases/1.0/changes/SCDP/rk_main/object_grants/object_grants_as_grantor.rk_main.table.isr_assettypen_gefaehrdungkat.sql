-- liquibase formatted sql
-- changeset RK_MAIN:1774554916736 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettypen_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettypen_gefaehrdungkat.sql:null:ec6ebd8246b1fb1627759609cc49c46a08ecd680:create

grant select on rk_main.isr_assettypen_gefaehrdungkat to rk_apex;

grant read on rk_main.isr_assettypen_gefaehrdungkat to rk_read;

