create index am_main.ix_hsb_name1 on
    am_main.hwas_sap_beauftragungen (
        name1
    );


-- sqlcl_snapshot {"hash":"562f16d0aaf7dca58a0fc9be1ddb21366d861824","type":"INDEX","name":"IX_HSB_NAME1","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>IX_HSB_NAME1</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>HWAS_SAP_BEAUFTRAGUNGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>NAME1</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}