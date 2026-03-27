create table am_main.hwas_prozesse_bsi_bausteine (
    przpbsi_uid   number default to_number(substr(
        rawtohex(sys_guid()),
        1,
        30
    ),
          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    bsi_uid_fk    number not null enable,
    przp_uid_fk   number not null enable,
    inserted_date date default sysdate,
    inserted_by   varchar2(100 byte),
    updated_date  date,
    updated_by    varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint pk_hwas_przpbsi_uid primary key ( przpbsi_uid )
        using index enable;

alter table am_main.hwas_prozesse_bsi_bausteine
    add constraint uk_hwas_przp_bsi unique ( przp_uid_fk,
                                             bsi_uid_fk )
        using index enable;


-- sqlcl_snapshot {"hash":"d9582e983eedbec31dbde88383d359b151f71887","type":"TABLE","name":"HWAS_PROZESSE_BSI_BAUSTEINE","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_PROZESSE_BSI_BAUSTEINE</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PRZPBSI_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>TO_NUMBER(SUBSTR(RAWTOHEX(SYS_GUID()), 1, 30),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BSI_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PRZP_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_DATE</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_HWAS_PRZPBSI_UID</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PRZPBSI_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UK_HWAS_PRZP_BSI</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>PRZP_UID_FK</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>BSI_UID_FK</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}