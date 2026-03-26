create table am_main.bsi_iv_relevanz (
    ivr_id number,
    name   varchar2(200 byte)
)
no inmemory;

alter table am_main.bsi_iv_relevanz add primary key ( ivr_id )
    using index enable;


-- sqlcl_snapshot {"hash":"4d05be1dc9a791232089f0555a0e1d2a2e3bd9c5","type":"TABLE","name":"BSI_IV_RELEVANZ","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>BSI_IV_RELEVANZ</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>IVR_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>IVR_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}