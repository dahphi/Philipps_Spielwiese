-- liquibase formatted sql
-- changeset RK_MAIN:1774561695245 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_parameter.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_parameter.sql:null:b2a655481394acb4ae5252f163fc4dc227a807a2:create

create table rk_main.isr_parameter (
    par_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    par_bezeichnung  varchar2(64 byte) not null enable,
    par_string_value varchar2(1024 byte) not null enable,
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_parameter
    add constraint isr_parameter_pk primary key ( par_uid )
        using index enable;

alter table rk_main.isr_parameter add constraint isr_parameter_uk1 unique ( par_bezeichnung )
    using index enable;

