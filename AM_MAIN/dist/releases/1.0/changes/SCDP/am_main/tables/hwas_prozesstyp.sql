-- liquibase formatted sql
-- changeset AM_MAIN:1774556573332 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_prozesstyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozesstyp.sql:null:ee03718f9670a693881908a970f97c7c85f6bb3f:create

create table am_main.hwas_prozesstyp (
    prz_uid      number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name         varchar2(100 byte) not null enable,
    beschreibung varchar2(4000 byte),
    inserted     date default sysdate not null enable,
    inserted_by  varchar2(100 byte) not null enable,
    updated      date,
    updated_by   varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozesstyp
    add constraint prz_uid_pk primary key ( prz_uid )
        using index enable;

alter table am_main.hwas_prozesstyp add unique ( name )
    using index enable;

