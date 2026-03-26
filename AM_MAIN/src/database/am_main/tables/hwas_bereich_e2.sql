create table am_main.hwas_bereich_e2 (
    be2_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    be2_bezeichnung varchar2(64 byte) not null enable,
    be2_nummer      number,
    kd1_uid         number,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_pk primary key ( be2_uid )
        using index enable;

alter table am_main.hwas_bereich_e2 add constraint hwas_bereich_e2_uk1 unique ( be2_bezeichnung )
    using index enable;

alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_uk2 unique ( be2_nummer,
                                                kd1_uid )
        using index enable;


-- sqlcl_snapshot {"hash":"61542bcf2178a794c9869c1a688a3fcc99640449","type":"TABLE","name":"HWAS_BEREICH_E2","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_BEREICH_E2</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>BE2_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BE2_BEZEICHNUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>64</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BE2_NUMMER</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>KD1_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_BEREICH_E2_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>BE2_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_BEREICH_E2_UK2</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>BE2_NUMMER</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>KD1_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_BEREICH_E2_UK1</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>BE2_BEZEICHNUNG</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}