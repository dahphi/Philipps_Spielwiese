create index am_main.ix_sap_lief_bezeichnung on
    am_main.sap_lieferanten (
        bezeichnung
    );


-- sqlcl_snapshot {"hash":"85741db49c33b7a1f35c66b291b481706bf385de","type":"INDEX","name":"IX_SAP_LIEF_BEZEICHNUNG","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>IX_SAP_LIEF_BEZEICHNUNG</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>SAP_LIEFERANTEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BEZEICHNUNG</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}