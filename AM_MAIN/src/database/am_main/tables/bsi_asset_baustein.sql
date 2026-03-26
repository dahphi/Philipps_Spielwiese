create table am_main.bsi_asset_baustein (
    ass_bsi_uid number default to_number(substr(
        rawtohex(sys_guid()),
        1,
        30
    ),
          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    bsi_uid_fk  number not null enable,
    ass_uid_fk  number not null enable,
    asset_typ   varchar2(50 byte) not null enable,
    inserted    date default sysdate not null enable,
    inserted_by varchar2(50 byte)
)
no inmemory;

alter table am_main.bsi_asset_baustein
    add constraint pk_bsi_asset_baustein primary key ( ass_bsi_uid )
        using index enable;

alter table am_main.bsi_asset_baustein
    add constraint uq_bsi_asset_baustein
        unique ( bsi_uid_fk,
                 ass_uid_fk,
                 asset_typ )
            using index enable;


-- sqlcl_snapshot {"hash":"efa8deb349fc38ba98477c8d8a394e81d52c2671","type":"TABLE","name":"BSI_ASSET_BAUSTEIN","schemaName":"AM_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AM_MAIN</SCHEMA>\n   <NAME>BSI_ASSET_BAUSTEIN</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASS_BSI_UID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <DEFAULT>TO_NUMBER(\n            SUBSTR(RAWTOHEX(SYS_GUID()),1,30),\n            'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'\n        )</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>BSI_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ASS_UID_FK</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ASSET_TYP</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED</NAME>\n            <DATATYPE>DATE</DATATYPE>\n            <DEFAULT>SYSDATE</DEFAULT>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>INSERTED_BY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>50</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_BSI_ASSET_BAUSTEIN</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ASS_BSI_UID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <UNIQUE_KEY_CONSTRAINT_LIST>\n         <UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>UQ_BSI_ASSET_BAUSTEIN</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>BSI_UID_FK</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>ASS_UID_FK</NAME>\n               </COL_LIST_ITEM>\n               <COL_LIST_ITEM>\n                  <NAME>ASSET_TYP</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </UNIQUE_KEY_CONSTRAINT_LIST_ITEM>\n      </UNIQUE_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n         <INMEMORY>\n            <STATE>DISABLE</STATE>\n         </INMEMORY>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}