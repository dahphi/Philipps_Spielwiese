-- liquibase formatted sql
-- changeset AM_MAIN:1774600123836 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_bereich_e2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_bereich_e2.sql:null:b3be85fe3bc1dc3510e674908dfc3f5fbc0df424:create

create table am_main.hwas_bereich_e2 (
    be2_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    be2_bezeichnung varchar2(64 byte) not null enable,
    be2_nummer      number,
    kd1_uid         number,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_pk primary key ( be2_uid )
        using index enable;

alter table am_main.hwas_bereich_e2 add constraint hwas_bereich_e2_uk1 unique ( be2_bezeichnung )
    using index enable;

alter table am_main.hwas_bereich_e2
    add constraint hwas_bereich_e2_uk2 unique ( be2_nummer,
                                                kd1_uid )
        using index enable;

