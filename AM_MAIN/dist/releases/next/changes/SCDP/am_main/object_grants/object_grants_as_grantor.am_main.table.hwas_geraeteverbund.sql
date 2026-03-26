-- liquibase formatted sql
-- changeset AM_MAIN:1774556567992 stripComments:false logicalFilePath:SCDP/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteverbund.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraeteverbund.sql:null:38d1cd54e395360dbe81d211bb566205b8958136:create

grant select on am_main.hwas_geraeteverbund to am_apex;

grant select on am_main.hwas_geraeteverbund to rk_apex;

grant read on am_main.hwas_geraeteverbund to rk_main;

grant read on am_main.hwas_geraeteverbund to rk_apex;

grant read on am_main.hwas_geraeteverbund to awh_read_jira;

