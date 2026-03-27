-- liquibase formatted sql
-- changeset AM_MAIN:1774600126522 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_raum.sql:null:d2420f15b6738a5b8fbfea4e0c084d5899235e12:create

create table am_main.hwas_raum (
    rm_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    rm_beschreibung varchar2(4000 byte),
    geb_uid         number not null enable,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    raum            varchar2(32 byte)
)
no inmemory;

alter table am_main.hwas_raum
    add constraint hwas_raum_pk primary key ( rm_uid )
        using index enable;

alter table am_main.hwas_raum add constraint hwas_raum_uk1 unique ( raum )
    using index enable;

