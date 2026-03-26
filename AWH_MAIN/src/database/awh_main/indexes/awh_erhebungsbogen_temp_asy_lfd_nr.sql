create unique index awh_main.awh_erhebungsbogen_temp_asy_lfd_nr on
    awh_main.awh_erhebungsbogen_temp (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"599d331319d6d60fcd3d88acc181cf5a2d291c08","type":"INDEX","name":"AWH_ERHEBUNGSBOGEN_TEMP_ASY_LFD_NR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEBUNGSBOGEN_TEMP_ASY_LFD_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEBUNGSBOGEN_TEMP</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}