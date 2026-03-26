create table awh_main.awh_proz_erheb_2 (
    ap2_lfd_nr              number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
    pro_lfd_nr              number not null enable,
    ap2_verarb_taet         varchar2(4000 byte),
    ap2_proz_ebene          varchar2(4000 byte),
    ap2_dat_einf            date,
    ap2_ueber_gp            varchar2(4000 byte),
    ap2_timestamp           timestamp(6),
    ap2_user                varchar2(100 byte),
    per_lfd_nr_verant_ap    varchar2(36 byte),
    per_lfd_nr_verant_fuehr varchar2(36 byte)
)
no inmemory;

create unique index awh_main.awh_proz_erheb_2_pk on
    awh_main.awh_proz_erheb_2 (
        ap2_lfd_nr
    );

alter table awh_main.awh_proz_erheb_2
    add constraint awh_proz_erheb_2_pk
        primary key ( ap2_lfd_nr )
            using index awh_main.awh_proz_erheb_2_pk enable;


-- sqlcl_snapshot {"hash":"6323b2b19af27ac69af02618358b72b7d5716174","type":"TABLE","name":"AWH_PROZ_ERHEB_2","schemaName":"AWH_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_PROZ_ERHEB_2</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>AP2_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PRO_LFD_NR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_VERARB_TAET</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_PROZ_EBENE</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_DAT_EINF</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_UEBER_GP</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>4000</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_TIMESTAMP</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>AP2_USER</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_AP</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>36</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PER_LFD_NR_VERANT_FUEHR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>36</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>AWH_PROZ_ERHEB_2_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>AP2_LFD_NR</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}