-- liquibase formatted sql
-- changeset RK_MAIN:1774561789293 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql:e53a22e55ebfe8d7fb4f20e31527ad6533eb9b3a:e6cf9a26f6d60a500ed8dd13a3337c8815ea0584:alter

grant select on rk_main.asm_am_assettypen to rk_apex;

grant read on rk_main.asm_am_assettypen to rk_apex;

