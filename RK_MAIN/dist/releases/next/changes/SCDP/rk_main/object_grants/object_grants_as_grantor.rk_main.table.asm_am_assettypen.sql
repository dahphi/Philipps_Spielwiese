-- liquibase formatted sql
-- changeset RK_MAIN:1774561690508 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.asm_am_assettypen.sql:null:db3c7b6b2856e2834b54d3a77b2decb674b68365:create

grant read on rk_main.asm_am_assettypen to awh_read_jira;

grant select on rk_main.asm_am_assettypen to rk_apex;

grant read on rk_main.asm_am_assettypen to rk_read;

grant read on rk_main.asm_am_assettypen to rk_apex;

