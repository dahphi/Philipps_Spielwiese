-- liquibase formatted sql
-- changeset RK_MAIN:1774561690557 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_assettyp_gefaehrdung.sql:null:e229a582e589af9de277a5bd0b567d398dde78be:create

grant read on rk_main.isr_assettyp_gefaehrdung to awh_read_jira;

grant select on rk_main.isr_assettyp_gefaehrdung to rk_apex;

