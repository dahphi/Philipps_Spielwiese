-- liquibase formatted sql
-- changeset RK_MAIN:1774554921622 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_massnahmenkontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_massnahmenkontext.sql:null:71c90fa07100909ecad989718f608b8359f8fb10:create

create table rk_main.isr_oam_massnahmenkontext (
    mkt_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    mkt_bezeichnung  varchar2(128 byte) not null enable,
    mkt_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    aktiv            number
)
no inmemory;

alter table rk_main.isr_oam_massnahmenkontext
    add constraint isr_oam_massnahmenkontext_pk primary key ( mkt_uid )
        using index enable;

alter table rk_main.isr_oam_massnahmenkontext add constraint isr_oam_massnahmenkontext_uk1 unique ( mkt_bezeichnung )
    using index enable;

