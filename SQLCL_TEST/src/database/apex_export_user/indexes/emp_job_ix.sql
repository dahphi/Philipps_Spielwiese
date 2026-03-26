create index apex_export_user.emp_job_ix on
    apex_export_user.employees (
        job_id
    );


-- sqlcl_snapshot {"hash":"8762fe9b3d07261752a55d61d754de627c84b05f","type":"INDEX","name":"EMP_JOB_IX","schemaName":"APEX_EXPORT_USER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n   <NAME>EMP_JOB_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n         <NAME>EMPLOYEES</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}