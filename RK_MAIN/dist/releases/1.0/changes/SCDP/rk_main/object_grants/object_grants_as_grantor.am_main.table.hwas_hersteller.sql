-- liquibase formatted sql
-- changeset RK_MAIN:1774554915788 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_hersteller.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_hersteller.sql:null:81b0fedda6176fd405ac0282b3bd35245c085861:create

grant read on am_main.hwas_hersteller to rk_main;

