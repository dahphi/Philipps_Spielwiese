-- liquibase formatted sql
-- changeset RK_MAIN:1774554915815 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.itwo_site.sql:null:c74a5486a30384a662dbd4b889768e72433c8b0c:create

grant read on am_main.itwo_site to rk_main;

