-- liquibase formatted sql
-- changeset AM_MAIN:1774557121685 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_tk_technologie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_tk_technologie.sql:null:7b9639e2d08a68e69f527a941ae76bab0c8a0dba:create

create table am_main.hwas_tk_technologie (
    tkt_uid                 number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    tkt_bezeichnung         varchar2(128 byte) not null enable,
    tkt_highlights          varchar2(4000 byte),
    ak3_uid                 number,
    inserted                date default sysdate not null enable,
    updated                 date,
    inserted_by             varchar2(100 char),
    updated_by              varchar2(100 char),
    tkt_lebenszyklus_status varchar2(16 byte),
    bip_uid                 number,
    krk_uid                 number
)
no inmemory;

alter table am_main.hwas_tk_technologie
    add constraint hwas_tk_technologie_pk primary key ( tkt_uid )
        using index enable;

