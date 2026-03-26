create unique index awh_main.table1_pk1 on
    awh_main.awh_tab_infosec_auditrl (
        adt_lfd_nr
    );


-- sqlcl_snapshot {"hash":"d9ad27859c67daa0f5166a908fc7931d11c8aa36","type":"INDEX","name":"TABLE1_PK1","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>TABLE1_PK1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_TAB_INFOSEC_AUDITRL</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ADT_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}