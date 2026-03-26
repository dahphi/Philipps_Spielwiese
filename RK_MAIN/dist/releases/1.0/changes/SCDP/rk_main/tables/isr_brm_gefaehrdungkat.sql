-- liquibase formatted sql
-- changeset RK_MAIN:1774561694763 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_brm_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_brm_gefaehrdungkat.sql:null:f664906878d7bef996c5f1cb6eebff95fb1d85d5:create

create table rk_main.isr_brm_gefaehrdungkat (
    gfk_uid     number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    gfk_name    varchar2(200 char) not null enable,
    inserted    date default sysdate not null enable,
    updated     date,
    inserted_by varchar2(100 char),
    updated_by  varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_brm_gefaehrdungkat
    add constraint isr_brm_gefaehrdungkat_pk primary key ( gfk_uid )
        using index enable;

