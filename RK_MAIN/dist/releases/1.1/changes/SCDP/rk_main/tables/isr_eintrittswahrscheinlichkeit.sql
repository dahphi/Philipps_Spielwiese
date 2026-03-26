-- liquibase formatted sql
-- changeset RK_MAIN:1774555713296 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_eintrittswahrscheinlichkeit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_eintrittswahrscheinlichkeit.sql:null:b99a3e55d8c00cb00be92569bf222db660ad5f9f:create

create table rk_main.isr_eintrittswahrscheinlichkeit (
    ews_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ews_bezeichnung varchar2(64 byte) not null enable,
    ews_wert        number not null enable,
    ews_prozentsatz number,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    ews_kriterien   varchar2(4000 byte)
)
no inmemory;

alter table rk_main.isr_eintrittswahrscheinlichkeit
    add constraint isr_eintrittswahrscheinlichkeit_pk primary key ( ews_uid )
        using index enable;

alter table rk_main.isr_eintrittswahrscheinlichkeit add constraint isr_eintrittswahrscheinlichkeit_uk1 unique ( ews_bezeichnung )
    using index enable;

