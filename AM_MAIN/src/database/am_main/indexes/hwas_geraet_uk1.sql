create unique index am_main.hwas_geraet_uk1 on
    am_main.hwas_geraet (
        grt_inventartnr
    );


-- sqlcl_snapshot {"hash":"3567ea472e5b50eb29cb116269bf5d3d457a80f1","type":"INDEX","name":"HWAS_GERAET_UK1","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_GERAET_UK1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>HWAS_GERAET</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GRT_INVENTARTNR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}