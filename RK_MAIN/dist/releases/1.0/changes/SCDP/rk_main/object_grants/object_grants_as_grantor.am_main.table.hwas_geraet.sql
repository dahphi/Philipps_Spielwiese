-- liquibase formatted sql
-- changeset RK_MAIN:1774561689633 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_geraet.sql:null:20ff47c67a53f9b50dbf3e4c5428b60b5ce339ba:create

grant read on am_main.hwas_geraet to rk_main;

