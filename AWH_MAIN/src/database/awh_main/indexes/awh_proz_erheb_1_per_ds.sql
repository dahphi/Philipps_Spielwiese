create unique index awh_main.awh_proz_erheb_1_per_ds on
    awh_main.awh_proz_erheb_1 (
        per_lfd_nr_ds
    );


-- sqlcl_snapshot {"hash":"d5c0f9b51d56bd428302e6a8af5da5a04bb14d33","type":"INDEX","name":"AWH_PROZ_ERHEB_1_PER_DS","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_1_PER_DS</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_DS</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}