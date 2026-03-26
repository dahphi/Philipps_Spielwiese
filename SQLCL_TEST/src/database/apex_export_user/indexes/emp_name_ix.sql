create index apex_export_user.emp_name_ix on
    apex_export_user.employees (
        last_name,
        first_name
    );


-- sqlcl_snapshot {"hash":"d5a862ed94aa5ddc7c14cde1aa50b04e45f588b7","type":"INDEX","name":"EMP_NAME_IX","schemaName":"APEX_EXPORT_USER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n   <NAME>EMP_NAME_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>LAST_NAME</NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FIRST_NAME</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}