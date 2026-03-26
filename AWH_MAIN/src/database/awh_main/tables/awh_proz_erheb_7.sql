create table awh_main.awh_proz_erheb_7 (
    ap7_lfd_nr       number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    pro_lfd_nr       number not null enable,
    exs_lfd_nr       number(38, 0) not null enable,
    ap7_beschreibung varchar2(4000 byte),
    ap7_timestamp    timestamp(6) not null enable,
    ap7_user         varchar2(100 byte)
)
no inmemory;

create unique index awh_main.awh_proz_erheb_7_pk on
    awh_main.awh_proz_erheb_7 (
        ap7_lfd_nr
    );

alter table awh_main.awh_proz_erheb_7
    add constraint awh_proz_erheb_7_pk
        primary key ( ap7_lfd_nr )
            using index awh_main.awh_proz_erheb_7_pk enable;


-- sqlcl_snapshot {"hash":"272dbcab8788f0dc65047c620faa20e033f9998c","type":"TABLE","name":"AWH_PROZ_ERHEB_7","schemaName":"AWH_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_7</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AP7_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PRO_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>EXS_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>38</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP7_BESCHREIBUNG</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP7_TIMESTAMP</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP7_USER</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_PROZ_ERHEB_7_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>AP7_LFD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}