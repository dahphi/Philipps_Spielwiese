create unique index am_main.unique_vd_index on
    am_main.hwas_vertragsdetails (
        vert_uid_fk,
        prod_uid_fk,
    nvl(ver_ti_uid_fk,(-1)),
    nvl(prod_bes_uid_fk,(-1)) );


-- sqlcl_snapshot {"hash":"d1a4ecd2b717ad0524243bbbf9a4b81aa0e2034f","type":"INDEX","name":"UNIQUE_VD_INDEX","schemaName":"AM_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>UNIQUE_VD_INDEX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AM_MAIN</SCHEMA>\n         <NAME>HWAS_VERTRAGSDETAILS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VERT_UID_FK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_UID_FK</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NVL(\"VER_TI_UID_FK\",(-1))</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NVL(\"PROD_BES_UID_FK\",(-1))</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}