-- liquibase formatted sql
-- changeset RK_MAIN:1774554916720 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangeloglock.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.databasechangeloglock.sql:null:c231ca3faf4cafd3fbf2d32ae0b5da8fb039ef7b:create

grant select on rk_main.databasechangeloglock to rk_apex;

