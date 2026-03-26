-- liquibase formatted sql
-- changeset RK_MAIN:1774554915979 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.view.v_members.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.v_members.sql:null:5f3cddc840bbcdd52453d3ff48333cb5a3efd5a6:create

grant select on core.v_members to rk_main;

grant read on core.v_members to rk_main;

