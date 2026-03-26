-- liquibase formatted sql
-- changeset RK_MAIN:1774555708438 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.core.view.awh_tab_person.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/core/object_grants/object_grants_as_grantor.core.view.awh_tab_person.sql:null:e4cb80d1463da6a63ff9f37dc5ce24074fcdc220:create

grant select on core.awh_tab_person to rk_main;

