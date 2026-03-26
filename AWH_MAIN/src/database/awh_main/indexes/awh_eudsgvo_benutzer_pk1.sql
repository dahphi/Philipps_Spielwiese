create unique index awh_main.awh_eudsgvo_benutzer_pk1 on
    awh_main.awh_eudsgvo_benutzer (
        eub_lfd_nr
    );


-- sqlcl_snapshot {"hash":"ccad4229c337367c1834eca97141dcb248b3142d","type":"INDEX","name":"AWH_EUDSGVO_BENUTZER_PK1","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_EUDSGVO_BENUTZER_PK1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_EUDSGVO_BENUTZER</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EUB_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}