create unique index awh_main.awh_erhebungsbogen_asy_lfd_nr on
    awh_main.awh_erhebungsbogen (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"40b9083dec3ce7ba73845b96506896e4c2afb017","type":"INDEX","name":"AWH_ERHEBUNGSBOGEN_ASY_LFD_NR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEBUNGSBOGEN_ASY_LFD_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEBUNGSBOGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}