create index awh_main.awh_proz_erheb_2_per_verant_ap on
    awh_main.awh_proz_erheb_2 (
        per_lfd_nr_verant_ap
    );


-- sqlcl_snapshot {"hash":"4d8fe41c7013b7d056dbca4728906e835d648cae","type":"INDEX","name":"AWH_PROZ_ERHEB_2_PER_VERANT_AP","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_2_PER_VERANT_AP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_2</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_AP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}