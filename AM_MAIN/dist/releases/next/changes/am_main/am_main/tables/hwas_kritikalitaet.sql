-- liquibase formatted sql
-- changeset AM_MAIN:1774600125467 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_kritikalitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_kritikalitaet.sql:null:14e2e8a4a831a71a6da3359fc3bd0ddc6dbf6a0e:create

create table am_main.hwas_kritikalitaet (
    krk_uid              number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    krk_bezeichnung      varchar2(128 byte) not null enable,
    krk_kurzbeschreibung varchar2(256 byte),
    krk_erlaeuterungen   varchar2(4000 byte),
    inserted             date default sysdate not null enable,
    updated              date,
    inserted_by          varchar2(100 char),
    updated_by           varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_kritikalitaet
    add constraint hwas_kritikalitaet_pk primary key ( krk_uid )
        using index enable;

alter table am_main.hwas_kritikalitaet add constraint hwas_kritikalitaet_uk1 unique ( krk_bezeichnung )
    using index enable;

