create unique index awh_main.awh_tab_verantwortungstyp_vet_name on
    awh_main.awh_tab_verantwortungstyp (
        vet_name
    );


-- sqlcl_snapshot {"hash":"155f45542299e1c63954ab9b9eb975a348d06953","type":"INDEX","name":"AWH_TAB_VERANTWORTUNGSTYP_VET_NAME","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_TAB_VERANTWORTUNGSTYP_VET_NAME</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_TAB_VERANTWORTUNGSTYP</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VET_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}