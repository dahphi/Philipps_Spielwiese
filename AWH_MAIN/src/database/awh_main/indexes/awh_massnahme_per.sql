create index awh_main.awh_massnahme_per on
    awh_main.awh_massnahme (
        per_lfd_nr_verantw
    );


-- sqlcl_snapshot {"hash":"dc7914369a73907854be41b0959bd825366441a3","type":"INDEX","name":"AWH_MASSNAHME_PER","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_MASSNAHME_PER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_MASSNAHME</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANTW</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}