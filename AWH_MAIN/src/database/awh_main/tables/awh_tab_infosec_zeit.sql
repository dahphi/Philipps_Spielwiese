create table awh_main.awh_tab_infosec_zeit (
    zet_lfd_nr number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    zet_name   varchar2(200 byte)
)
no inmemory;

create unique index awh_main.awh_tab_infosec_zeit_pk on
    awh_main.awh_tab_infosec_zeit (
        zet_lfd_nr
    );

alter table awh_main.awh_tab_infosec_zeit
    add constraint awh_tab_infosec_vollzeit_pk
        primary key ( zet_lfd_nr )
            using index awh_main.awh_tab_infosec_zeit_pk enable;


-- sqlcl_snapshot {"hash":"0ec4a699741ee5336ab74e007d1c7e1d85ada20d","type":"TABLE","name":"AWH_TAB_INFOSEC_ZEIT","schemaName":"AWH_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_TAB_INFOSEC_ZEIT</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZET_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZET_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_TAB_INFOSEC_VOLLZEIT_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ZET_LFD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}