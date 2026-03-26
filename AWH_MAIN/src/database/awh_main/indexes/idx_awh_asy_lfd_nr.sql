create index awh_main.idx_awh_asy_lfd_nr on
    awh_main.awh_system_attribute (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"98f467a24b25e5ac974a7dbe7e40511458bc7778","type":"INDEX","name":"IDX_AWH_ASY_LFD_NR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>IDX_AWH_ASY_LFD_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_SYSTEM_ATTRIBUTE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}