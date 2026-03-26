-- liquibase formatted sql
-- changeset RK_MAIN:1774554916680 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql:null:e6cf9a26f6d60a500ed8dd13a3337c8815ea0584:create

grant select on rk_main.asm_am_assettypen to rk_apex;

grant read on rk_main.asm_am_assettypen to awh_read_jira;

grant read on rk_main.asm_am_assettypen to rk_read;

grant read on rk_main.asm_am_assettypen to rk_apex;

