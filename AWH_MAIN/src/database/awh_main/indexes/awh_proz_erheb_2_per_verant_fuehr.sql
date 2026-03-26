create index awh_main.awh_proz_erheb_2_per_verant_fuehr on
    awh_main.awh_proz_erheb_2 (
        per_lfd_nr_verant_fuehr
    );


-- sqlcl_snapshot {"hash":"b464d954a30528c8f4da21b913259b23b4e094d0","type":"INDEX","name":"AWH_PROZ_ERHEB_2_PER_VERANT_FUEHR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_2_PER_VERANT_FUEHR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_PROZ_ERHEB_2</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_FUEHR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}