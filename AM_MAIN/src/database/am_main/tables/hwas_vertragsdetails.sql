create table am_main.hwas_vertragsdetails (
    vd_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    prod_uid_fk     number not null enable,
    vert_uid_fk     number not null enable,
    inserted        date default sysdate,
    inserted_by     varchar2(100 char),
    updated         date,
    updated_by      varchar2(100 char),
    ver_ti_uid_fk   number,
    prod_bes_uid_fk number,
    bemerkung       varchar2(400 byte)
)
no inmemory;

alter table am_main.hwas_vertragsdetails
    add constraint pk_hwas_vertragsdetails primary key ( vd_uid )
        using index enable;


-- sqlcl_snapshot {"hash":"fccdc9aeecf5dfd21c61139c8484ea1d8d81fc8a","type":"TABLE","name":"HWAS_VERTRAGSDETAILS","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_VERTRAGSDETAILS</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VD_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VERT_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VER_TI_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_BES_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BEMERKUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>400</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_HWAS_VERTRAGSDETAILS</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>VD_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}