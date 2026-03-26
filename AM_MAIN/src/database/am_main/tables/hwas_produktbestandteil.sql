create table am_main.hwas_produktbestandteil (
    prod_bes_uid number(*, 0) not null enable,
    name         varchar2(255 byte) not null enable,
    prod_uid_fk  number(*, 0) not null enable,
    kommentar    varchar2(4000 byte),
    inserted     date,
    inserted_by  varchar2(255 byte),
    updated      date,
    updated_by   varchar2(255 byte)
)
no inmemory;

alter table am_main.hwas_produktbestandteil
    add constraint hwas_produktbestandteil_uk1 unique ( prod_uid_fk,
                                                        name )
        using index enable;

alter table am_main.hwas_produktbestandteil
    add constraint pk_hwas_produktbestandteil primary key ( prod_bes_uid )
        using index enable;


-- sqlcl_snapshot {"hash":"2359ef197def5ec7a3e0b1f7f75f90e0ecde9241","type":"TABLE","name":"HWAS_PRODUKTBESTANDTEIL","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_PRODUKTBESTANDTEIL</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PROD_BES_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PROD_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KOMMENTAR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_HWAS_PRODUKTBESTANDTEIL</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PROD_BES_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_PRODUKTBESTANDTEIL_UK1</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PROD_UID_FK</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>NAME</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}