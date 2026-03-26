create table am_main.hwas_geraet (
    grt_uid                     number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    grt_inventartnr             varchar2(32 byte),
    mdl_uid                     number,
    grt_assetname               varchar2(64 byte),
    grt_herstell_inbetrnhm_jahr number,
    rm_uid                      number,
    inserted                    date default sysdate not null enable,
    updated                     date,
    inserted_by                 varchar2(100 char),
    updated_by                  varchar2(100 char),
    grt_link_fremdsystem        varchar2(256 byte),
    grt_zielsystem              varchar2(32 byte),
    hst_uid                     number,
    grt_data_custodian          varchar2(64 byte),
    quellsystem_id              number,
    grt_quellsystem             varchar2(128 byte) default 'Hardware-DB',
    gvb_uid                     number,
    fkl_uid                     number,
    geb_uid                     number,
    status                      number
)
no inmemory;

create unique index am_main.hwas_geraet_uk2 on
    am_main.hwas_geraet (
        grt_assetname
    );

alter table am_main.hwas_geraet
    add constraint hwas_geraet_pk primary key ( grt_uid )
        using index enable;

alter table am_main.hwas_geraet
    add constraint hwas_geraet_uk1 unique ( grt_assetname )
        using index am_main.hwas_geraet_uk2 enable;


-- sqlcl_snapshot {"hash":"d3af9e2d0656766c62f7b57c8c79f5e7663f5368","type":"TABLE","name":"HWAS_GERAET","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>HWAS_GERAET</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>GRT_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_INVENTARTNR</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>MDL_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_ASSETNAME</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>64</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_HERSTELL_INBETRNHM_JAHR</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>RM_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>UPDATED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>100</LENGTH>\n            <CHAR_SEMANTICS></CHAR_SEMANTICS>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_LINK_FREMDSYSTEM</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>256</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_ZIELSYSTEM</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>32</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>HST_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_DATA_CUSTODIAN</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>64</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>QUELLSYSTEM_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GRT_QUELLSYSTEM</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>128</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <DEFAULT>'Hardware-DB'</DEFAULT>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GVB_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>FKL_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>GEB_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>STATUS</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_GERAET_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>GRT_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>HWAS_GERAET_UK1</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>GRT_ASSETNAME</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}