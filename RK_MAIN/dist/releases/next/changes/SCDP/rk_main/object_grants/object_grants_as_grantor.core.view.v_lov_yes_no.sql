-- liquibase formatted sql
-- changeset RK_MAIN:1774561689820 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.view.v_lov_yes_no.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_lov_yes_no.sql:null:cc2e059af4b202320ae4ce2ec03c0000b519e4f6:create

grant select on core.v_lov_yes_no to rk_main;

