-- liquibase formatted sql
-- changeset RK_MAIN:1774561694966 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_massnahmenkomplexitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_massnahmenkomplexitaet.sql:null:73902efe50b8584ce67e3f081364a6ed07326e44:create

create table rk_main.isr_massnahmenkomplexitaet (
    mkp_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    mkp_bezeichnung  varchar2(128 byte) not null enable,
    mkp_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_massnahmenkomplexitaet
    add constraint isr_massnahmenkomplexitaet_pk primary key ( mkp_uid )
        using index enable;

alter table rk_main.isr_massnahmenkomplexitaet add constraint isr_massnahmenkomplexitaet_uk1 unique ( mkp_bezeichnung )
    using index enable;

