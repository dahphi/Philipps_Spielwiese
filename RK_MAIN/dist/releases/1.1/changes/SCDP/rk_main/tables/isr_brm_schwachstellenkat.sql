-- liquibase formatted sql
-- changeset RK_MAIN:1774555713275 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_brm_schwachstellenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_brm_schwachstellenkat.sql:null:d59e31ac6f5eb2adc93530e8ff1c032b6db60106:create

create table rk_main.isr_brm_schwachstellenkat (
    ska_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ska_titel        varchar2(128 byte) not null enable,
    ska_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    aktiv            number default 1 not null enable
)
no inmemory;

alter table rk_main.isr_brm_schwachstellenkat
    add constraint isr_brm_schwachstellenkat_pk primary key ( ska_uid )
        using index enable;

alter table rk_main.isr_brm_schwachstellenkat add constraint isr_brm_schwachstellenkat_uk1 unique ( ska_titel )
    using index enable;

