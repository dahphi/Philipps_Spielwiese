create table roma_main.ftth_ws_sync_stornogruende (
    key                      varchar2(255 byte) not null enable,
    label                    varchar2(255 byte) not null enable,
    apex$sync_step_static_id varchar2(255 byte),
    apex$row_sync_timestamp  timestamp(6) with time zone,
    notify_customer          varchar2(5 byte)
);

create unique index roma_main.ftth_ws_sync_stornogruende_pk on
    roma_main.ftth_ws_sync_stornogruende (
        key
    );

alter table roma_main.ftth_ws_sync_stornogruende
    add constraint ftth_ws_sync_stornogruende_pk
        primary key ( key )
            using index roma_main.ftth_ws_sync_stornogruende_pk enable;


-- sqlcl_snapshot {"hash":"69147587b77eb47f9189663089d3ce746f92e97a","type":"TABLE","name":"FTTH_WS_SYNC_STORNOGRUENDE","schemaName":"ROMA_MAIN","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>ROMA_MAIN</SCHEMA>\n   <NAME>FTTH_WS_SYNC_STORNOGRUENDE</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>KEY</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>LABEL</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APEX$SYNC_STEP_STATIC_ID</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>255</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>APEX$ROW_SYNC_TIMESTAMP</NAME>\n            <DATATYPE>TIMESTAMP_WITH_TIMEZONE</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>NOTIFY_CUSTOMER</NAME>\n            <DATATYPE>VARCHAR2</DATATYPE>\n            <LENGTH>5</LENGTH>\n            <COLLATE_NAME>USING_NLS_COMP</COLLATE_NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>FTTH_WS_SYNC_STORNOGRUENDE_PK</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>KEY</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}