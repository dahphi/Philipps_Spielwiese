create index am_main.idx_sap_import_prod_name1 on
    am_main.sap_import_prod (
        name1
    );


-- sqlcl_snapshot {"hash":"d440fbc42cd22755d6887c3d6f362aaf0a4fd344","type":"INDEX","name":"IDX_SAP_IMPORT_PROD_NAME1","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>IDX_SAP_IMPORT_PROD_NAME1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>SAP_IMPORT_PROD</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME1</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}