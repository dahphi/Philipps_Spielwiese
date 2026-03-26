create index apex_export_user.jhist_job_ix on
    apex_export_user.job_history (
        job_id
    );


-- sqlcl_snapshot {"hash":"ce54c6dee38f855dd98670a4225f8679932477e8","type":"INDEX","name":"JHIST_JOB_IX","schemaName":"APEX_EXPORT_USER","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n   <NAME>JHIST_JOB_IX</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>APEX_EXPORT_USER</SCHEMA>\n         <NAME>JOB_HISTORY</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>JOB_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      \n   </TABLE_INDEX>\n</INDEX>"}