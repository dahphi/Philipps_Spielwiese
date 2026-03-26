create index apex_export_user.emp_department_ix on
    apex_export_user.employees (
        department_id
    );


-- sqlcl_snapshot {"hash":"7bb54c9305166ea07610e5a50ba12ca89f50ea24","type":"INDEX","name":"EMP_DEPARTMENT_IX","schemaName":"APEX_EXPORT_USER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n   <NAME>EMP_DEPARTMENT_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>DEPARTMENT_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}