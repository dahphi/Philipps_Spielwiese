create index awh_main.awh_proz_erheb_2_1_per_verant_fk on
    awh_main.awh_proz_erheb_2_1 (
        per_lfd_nr_verant_fk
    );


-- sqlcl_snapshot {"hash":"9e2316c6f370649cf032036795e590c4fad8678f","type":"INDEX","name":"AWH_PROZ_ERHEB_2_1_PER_VERANT_FK","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_2_1_PER_VERANT_FK</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_2_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_FK</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}