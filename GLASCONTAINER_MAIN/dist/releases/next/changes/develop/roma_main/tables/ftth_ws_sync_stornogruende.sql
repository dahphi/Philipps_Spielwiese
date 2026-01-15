-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991404 stripComments:false logicalFilePath:develop/roma_main/tables/ftth_ws_sync_stornogruende.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/ftth_ws_sync_stornogruende.sql:null:615ed0f935e6289569c2dbc841a2f09815edf8e1:create

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

