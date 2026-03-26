create table awh_main.awh_tab_schutz_vertraulich (
    vet_lfd_nr    number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    vet_bedeutung varchar2(2000 byte),
    inserted      date,
    inserted_by   varchar2(200 byte),
    updated       date,
    updated_by    varchar2(200 byte),
    sequenz       number
)
no inmemory;

create unique index awh_main.awh_tab_schutz_vertraulich_uk1 on
    awh_main.awh_tab_schutz_vertraulich (
        vet_bedeutung
    );

create unique index awh_main.awh_tab_schutz_vet_pk on
    awh_main.awh_tab_schutz_vertraulich (
        vet_lfd_nr
    );

alter table awh_main.awh_tab_schutz_vertraulich
    add constraint awh_tab_schutz_vertraulich_uk1 unique ( vet_bedeutung )
        using index awh_main.awh_tab_schutz_vertraulich_uk1 enable;

alter table awh_main.awh_tab_schutz_vertraulich add constraint awh_tab_schutz_vertraulich_uk2 unique ( sequenz )
    using index enable;

alter table awh_main.awh_tab_schutz_vertraulich
    add constraint awh_tab_schutz_vet_pk
        primary key ( vet_lfd_nr )
            using index awh_main.awh_tab_schutz_vet_pk enable;


-- sqlcl_snapshot {"hash":"0ee2fcd1ea8d96c8fa102489fdd3d2e748ea638a","type":"TABLE","name":"AWH_TAB_SCHUTZ_VERTRAULICH","schemaName":"AWH_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_TAB_SCHUTZ_VERTRAULICH</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>VET_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT_ON_NULL>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT_ON_NULL>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VET_BEDEUTUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>2000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>200</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>SEQUENZ</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_TAB_SCHUTZ_VET_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>VET_LFD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_TAB_SCHUTZ_VERTRAULICH_UK2</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>SEQUENZ</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_TAB_SCHUTZ_VERTRAULICH_UK1</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>VET_BEDEUTUNG</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}