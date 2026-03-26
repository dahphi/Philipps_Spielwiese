-- liquibase formatted sql
-- changeset RK_MAIN:1774555708260 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.am_main.table.hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/am_main/object_grants/object_grants_as_grantor.am_main.table.hwas_elem_geraet.sql:null:18e0c656ac71fee68ac64cb4191aa6bb0f23a922:create

grant read on am_main.hwas_elem_geraet to rk_main;

