create index awh_main.awh_erheb_1_fachbereich_per on
    awh_main.awh_erheb_1_fachbereich (
        per_lfd_nr
    );


-- sqlcl_snapshot {"hash":"f5409f4d539fc9ceb0ce8ccbecb0f17ac921ba14","type":"INDEX","name":"AWH_ERHEB_1_FACHBEREICH_PER","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEB_1_FACHBEREICH_PER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEB_1_FACHBEREICH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}