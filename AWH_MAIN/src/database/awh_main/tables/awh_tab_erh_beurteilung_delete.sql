create table awh_main.awh_tab_erh_beurteilung_delete (
    ebu_lfd_nr number,
    ebu_name   varchar2(100 byte) not null enable
)
no inmemory;

alter table awh_main.awh_tab_erh_beurteilung_delete
    add constraint awh_tab_erh_beurteilung_del_pk
        primary key ( ebu_lfd_nr )
            using index (
                create unique index awh_main.awh_tab_erh_beurteilung_pk on
                    awh_main.awh_tab_erh_beurteilung_delete (
                        ebu_lfd_nr
                    )
            ) enable;


-- sqlcl_snapshot {"hash":"02c64e9fac00ba097a6b2ef7b4f884801b43a516","type":"TABLE","name":"AWH_TAB_ERH_BEURTEILUNG_DELETE","schemaName":"AWH_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_TAB_ERH_BEURTEILUNG_DELETE</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>EBU_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EBU_NAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_TAB_ERH_BEURTEILUNG_DEL_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>EBU_LFD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX>\n               <INDEX version=\"1.0\">\n                  <UNIQUE></UNIQUE>\n                  <SCHEMA>AWH_MAIN</SCHEMA>\n                  <NAME>AWH_TAB_ERH_BEURTEILUNG_PK</NAME>\n                  <TABLE_INDEX>\n                     <ON_TABLE>\n                        <SCHEMA>AWH_MAIN</SCHEMA>\n                        <NAME>AWH_TAB_ERH_BEURTEILUNG_DELETE</NAME>\n                     </ON_TABLE>\n                     <COL_LIST>\n                        <COL_LIST_ITEM>\n                           <NAME>EBU_LFD_NR</NAME>\n                        </COL_LIST_ITEM>\n                     </COL_LIST>\n                  </TABLE_INDEX>\n               </INDEX>\n            </USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}