create index awh_main.awh_proz_erheb_2_1_per_verant_fuehr on
    awh_main.awh_proz_erheb_2_1 (
        per_lfd_nr_verant_ap
    );


-- sqlcl_snapshot {"hash":"a2744abaf6b93eca0e7c56fdca198c9fd6deb1d2","type":"INDEX","name":"AWH_PROZ_ERHEB_2_1_PER_VERANT_FUEHR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_2_1_PER_VERANT_FUEHR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_2_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_AP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}