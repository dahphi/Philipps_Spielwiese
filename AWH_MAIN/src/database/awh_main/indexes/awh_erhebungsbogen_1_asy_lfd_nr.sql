create unique index awh_main.awh_erhebungsbogen_1_asy_lfd_nr on
    awh_main.awh_erhebungsbogen_1 (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"b3d8a0de05d6554ea0a05552ef1cdda97a1df73a","type":"INDEX","name":"AWH_ERHEBUNGSBOGEN_1_ASY_LFD_NR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEBUNGSBOGEN_1_ASY_LFD_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEBUNGSBOGEN_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}