-- liquibase formatted sql
-- changeset RK_MAIN:1774555709130 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql:null:2ea362b08f12dc949a3dd36e4f98fa06c95b65e6:create

grant select on rk_main.isr_assettyp_gefaehrdung to rk_apex;

grant read on rk_main.isr_assettyp_gefaehrdung to awh_read_jira;

