create index awh_main.awh_proz_erheb_1_per_vertr on
    awh_main.awh_proz_erheb_1 (
        per_lfd_nr_vertr
    );


-- sqlcl_snapshot {"hash":"38d390e28d1f1245ec4c2edac059dc048f54926c","type":"INDEX","name":"AWH_PROZ_ERHEB_1_PER_VERTR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_1_PER_VERTR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERTR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}