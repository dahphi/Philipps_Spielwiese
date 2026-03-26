-- liquibase formatted sql
-- changeset RK_MAIN:1774561694779 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_brm_massnahmenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_brm_massnahmenkat.sql:null:77014a0a0b4933c76261cab13eab29d498d7d3a8:create

create table rk_main.isr_brm_massnahmenkat (
    mka_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    mka_titel        varchar2(128 byte) not null enable,
    mka_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    aktiv            number default 1
)
no inmemory;

alter table rk_main.isr_brm_massnahmenkat
    add constraint isr_brm_massnahmenkat_pk primary key ( mka_uid )
        using index enable;

alter table rk_main.isr_brm_massnahmenkat add constraint isr_brm_massnahmenkat_uk1 unique ( mka_titel )
    using index enable;

