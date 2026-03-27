-- liquibase formatted sql
-- changeset AM_MAIN:1774600123954 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_betriebsinterner_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_betriebsinterner_prozess.sql:null:13a2e8996f7af7ada521dca5730ca18d871a45bc:create

create table am_main.hwas_betriebsinterner_prozess (
    bip_uid                   number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    bip_bezeichnung           varchar2(128 byte) not null enable,
    ak3_uid                   number,
    bip_zusammenfassung       varchar2(4000 byte),
    bip_abhaenigkeit_logistik number default 0,
    bip_bescheibung_abh_log   varchar2(4000 byte),
    inserted                  date default sysdate not null enable,
    updated                   date,
    inserted_by               varchar2(100 char),
    updated_by                varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_betriebsinterner_prozess
    add constraint hwas_betriebsinterner_prozess_pk primary key ( bip_uid )
        using index enable;

alter table am_main.hwas_betriebsinterner_prozess add constraint hwas_betriebsinterner_prozess_uk1 unique ( bip_bezeichnung )
    using index enable;

