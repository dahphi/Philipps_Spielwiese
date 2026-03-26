create index awh_main.awh_erhebungsbogen_per on
    awh_main.awh_erhebungsbogen (
        per_lfd_nr_ausf_per
    );


-- sqlcl_snapshot {"hash":"6af848339f4acb42c5a6211ca697a96e47df1759","type":"INDEX","name":"AWH_ERHEBUNGSBOGEN_PER","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEBUNGSBOGEN_PER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEBUNGSBOGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_AUSF_PER</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}