-- liquibase formatted sql
-- changeset RK_MAIN:1774561690391 stripComments:false logicalFilePath:SCDP/rk_main/indexes/asm_am_assettypen_uk1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/indexes/asm_am_assettypen_uk1.sql:null:a224fa3f2aabb9b043ee46aef29bfb565af9434f:create

create unique index rk_main.asm_am_assettypen_uk1 on
    rk_main.asm_am_assettypen (
        ast_name
    );

