-- liquibase formatted sql
-- changeset AM_MAIN:1774600101910 stripComments:false logicalFilePath:am_main/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site.sql:null:28d4ec8e759e66bac114bfe56364a0d4325ee8e7:create

grant select on am_main.itwo_site to am_apex;

grant select on am_main.itwo_site to rk_apex;

grant read on am_main.itwo_site to rk_main;

grant read on am_main.itwo_site to rk_apex;

