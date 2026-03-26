-- liquibase formatted sql
-- changeset RK_MAIN:1774555713086 stripComments:false logicalFilePath:SCDP/rk_main/tables/asm_am_erkenntnisquellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/asm_am_erkenntnisquellen.sql:null:789a2f60f820e38423432b8a55002b80d7af42cb:create

create table rk_main.asm_am_erkenntnisquellen (
    ekq_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ekq_bezeichnung  varchar2(128 byte) not null enable,
    ekq_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    ekw_input_sans   varchar2(4000 byte)
)
no inmemory;

alter table rk_main.asm_am_erkenntnisquellen
    add constraint asm_am_erkenntnisquellen_pk primary key ( ekq_uid )
        using index enable;

alter table rk_main.asm_am_erkenntnisquellen add constraint asm_am_erkenntnisquellen_uk1 unique ( ekq_bezeichnung )
    using index enable;

