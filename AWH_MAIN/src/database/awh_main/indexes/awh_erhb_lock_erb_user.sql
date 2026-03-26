create index awh_main.awh_erhb_lock_erb_user on
    awh_main.awh_erhb_lock (
        erb_user
    );


-- sqlcl_snapshot {"hash":"925fb54b59dffaccf0a764b4267891588fc403cc","type":"INDEX","name":"AWH_ERHB_LOCK_ERB_USER","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHB_LOCK_ERB_USER</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHB_LOCK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ERB_USER</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}