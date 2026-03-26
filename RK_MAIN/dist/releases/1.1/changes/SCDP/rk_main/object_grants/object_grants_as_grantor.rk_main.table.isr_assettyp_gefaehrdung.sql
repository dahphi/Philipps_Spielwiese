-- liquibase formatted sql
-- changeset RK_MAIN:1774561789318 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql:dc077574afa54990807a49d1d4cac34e91427a50:2ea362b08f12dc949a3dd36e4f98fa06c95b65e6:alter

grant select on rk_main.isr_assettyp_gefaehrdung to rk_apex;

