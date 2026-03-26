create index apex_export_user.loc_city_ix on
    apex_export_user.locations (
        city
    );


-- sqlcl_snapshot {"hash":"bd80e52373b875c41d6e391f8ae2cd2f2b53cf94","type":"INDEX","name":"LOC_CITY_IX","schemaName":"APEX_EXPORT_USER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n   <NAME>LOC_CITY_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n         <NAME>LOCATIONS</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>CITY</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}