create index awh_main.awh_proz_erheb_1_per_ges on
    awh_main.awh_proz_erheb_1 (
        per_lfd_nr_ges_ver
    );


-- sqlcl_snapshot {"hash":"31937c8f2f95d1892357936aa6050d611dd32922","type":"INDEX","name":"AWH_PROZ_ERHEB_1_PER_GES","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_1_PER_GES</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_1</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_GES_VER</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}