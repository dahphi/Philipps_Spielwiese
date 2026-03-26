-- liquibase formatted sql
-- changeset RK_MAIN:1774555713790 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_wirkbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_wirkbereich.sql:null:3bcfe8bd555845cfbc82bfb28421b07e5f10e693:create

create table rk_main.isr_wirkbereich (
    wbr_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    wbr_bezeichnung varchar2(256 byte) not null enable,
    wbr_responsible varchar2(256 byte),
    wbr_accountable varchar2(256 byte),
    wbr_supportive  varchar2(256 byte),
    wbr_consulted   varchar2(256 byte),
    wbi_informed    varchar2(256 byte),
    i2a_uids        varchar2(4000 byte),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_wirkbereich
    add constraint isr_wirkbereich_pk primary key ( wbr_uid )
        using index enable;

alter table rk_main.isr_wirkbereich add constraint isr_wirkbereich_uk1 unique ( wbr_bezeichnung )
    using index enable;

