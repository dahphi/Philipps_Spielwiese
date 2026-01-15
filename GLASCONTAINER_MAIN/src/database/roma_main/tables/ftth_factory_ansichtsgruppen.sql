create table roma_main.ftth_factory_ansichtsgruppen (
    ftthag_id   number(*, 0) not null enable,
    status      varchar2(3 byte) not null enable,
    name        varchar2(50 byte) not null enable,
    reihenfolge number(*, 0)
);

alter table roma_main.ftth_factory_ansichtsgruppen
    add constraint ftth_factory_ansichtsgruppen_pk primary key ( ftthag_id )
        using index enable;

alter table roma_main.ftth_factory_ansichtsgruppen flashback archive mongo


-- sqlcl_snapshot {"hash":"594a9762fc65d918754fa30d5e452cc47692003d","type":"TABLE","name":"FTTH_FACTORY_ANSICHTSGRUPPEN","schemaName":"ROMA_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>ROMA_MAIN</SCHEMA>\n   <NAME>FTTH_FACTORY_ANSICHTSGRUPPEN</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>FTTHAG_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>3</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>REIHENFOLGE</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>FTTH_FACTORY_ANSICHTSGRUPPEN_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>FTTHAG_ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n      <TABLE_PROPERTIES>\n         <FLASHBACK_ARCHIVE>MONGO</FLASHBACK_ARCHIVE>\n      </TABLE_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}