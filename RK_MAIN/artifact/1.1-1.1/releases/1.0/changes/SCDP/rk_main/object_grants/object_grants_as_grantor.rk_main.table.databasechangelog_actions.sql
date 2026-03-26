-- liquibase formatted sql
-- changeset RK_MAIN:1774554916716 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangelog_actions.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangelog_actions.sql:null:afdcaf8d35c9a0722d1c3c6d908ca16284d1e474:create

grant select on rk_main.databasechangelog_actions to rk_apex;

