create unique index rk_main.asm_am_assettypen_uk1 on
    rk_main.asm_am_assettypen (
        ast_name
    );


-- sqlcl_snapshot {"hash":"a224fa3f2aabb9b043ee46aef29bfb565af9434f","type":"INDEX","name":"ASM_AM_ASSETTYPEN_UK1","schemaName":"RK_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>RK_MAIN</SCHEMA>\n   <NAME>ASM_AM_ASSETTYPEN_UK1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>RK_MAIN</SCHEMA>\n         <NAME>ASM_AM_ASSETTYPEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AST_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}