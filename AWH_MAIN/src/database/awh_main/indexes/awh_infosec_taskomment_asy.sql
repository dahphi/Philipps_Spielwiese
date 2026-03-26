create index awh_main.awh_infosec_taskomment_asy on
    awh_main.awh_infosec_taskomment (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"118c4d23d8c257e31f5d8a3546da5850d1160ce1","type":"INDEX","name":"AWH_INFOSEC_TASKOMMENT_ASY","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_INFOSEC_TASKOMMENT_ASY</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_INFOSEC_TASKOMMENT</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}