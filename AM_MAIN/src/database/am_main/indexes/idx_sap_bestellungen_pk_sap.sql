create index am_main.idx_sap_bestellungen_pk_sap on
    am_main.hwas_sap_beauftragungen (
        primarykey_sap
    );


-- sqlcl_snapshot {"hash":"757bf26e371cb3614f77914c745d91284bb4f952","type":"INDEX","name":"IDX_SAP_BESTELLUNGEN_PK_SAP","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>IDX_SAP_BESTELLUNGEN_PK_SAP</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>HWAS_SAP_BEAUFTRAGUNGEN</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PRIMARYKEY_SAP</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}