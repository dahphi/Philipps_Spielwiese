-- liquibase formatted sql
-- changeset RK_MAIN:1774561694951 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_massnahme_kontext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_massnahme_kontext.sql:null:d7f2a9f1876f3e3a7f6850fcfb71b9c4870bedd2:create

create table rk_main.isr_massnahme_kontext (
    mk_id       number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    msn_uid     number not null enable,
    mkt_uid     number not null enable,
    inserted    date,
    inserted_by varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_massnahme_kontext
    add constraint massnahme_kontext_pk primary key ( mk_id )
        using index enable;

