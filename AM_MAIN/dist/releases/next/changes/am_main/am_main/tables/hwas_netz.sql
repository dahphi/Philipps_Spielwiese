-- liquibase formatted sql
-- changeset AM_MAIN:1774600125790 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_netz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_netz.sql:null:98c6ec9def251b53edb48fd4132655cd01ccc01e:create

create table am_main.hwas_netz (
    net_uid               number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    net_bezeichnung       varchar2(32 byte) not null enable,
    net_beschreibung      varchar2(4000 byte),
    ak3_uid               number,
    tkt_uid               number not null enable,
    ad_san_anspechpartner varchar2(32 byte),
    inserted              date default sysdate not null enable,
    updated               date,
    inserted_by           varchar2(100 char),
    updated_by            varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_netz
    add constraint hwas_netz_pk primary key ( net_uid )
        using index enable;

alter table am_main.hwas_netz add constraint hwas_netz_uk1 unique ( net_bezeichnung )
    using index enable;

