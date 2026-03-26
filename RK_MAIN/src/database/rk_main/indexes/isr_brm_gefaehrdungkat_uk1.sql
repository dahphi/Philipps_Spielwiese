create unique index rk_main.isr_brm_gefaehrdungkat_uk1 on
    rk_main.isr_brm_gefaehrdungkat (
        gfk_name
    );


-- sqlcl_snapshot {"hash":"fe74ddc280eef4ea2f2950c05822c9e78357a63b","type":"INDEX","name":"ISR_BRM_GEFAEHRDUNGKAT_UK1","schemaName":"RK_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>RK_MAIN</SCHEMA>\n   <NAME>ISR_BRM_GEFAEHRDUNGKAT_UK1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>RK_MAIN</SCHEMA>\n         <NAME>ISR_BRM_GEFAEHRDUNGKAT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GFK_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}