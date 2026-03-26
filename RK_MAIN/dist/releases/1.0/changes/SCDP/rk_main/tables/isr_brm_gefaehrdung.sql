-- liquibase formatted sql
-- changeset RK_MAIN:1774561694746 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_brm_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_brm_gefaehrdung.sql:null:1703a985a7e499a85d0f58d904bf87fea2c1fd14:create

create table rk_main.isr_brm_gefaehrdung (
    gef_uid           number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    gef_titel         varchar2(1000 byte) not null enable,
    gef_beschreibung  varchar2(4000 byte),
    inserted          date default sysdate not null enable,
    updated           date,
    inserted_by       varchar2(100 char),
    updated_by        varchar2(100 char),
    aktiv             number default 1,
    gef_aut_betroffen number default 0,
    gef_int_betroffen number default 0,
    gef_vef_betroffen number default 0,
    gef_vet_betroffen number default 0,
    gfk_uid           number
)
no inmemory;

alter table rk_main.isr_brm_gefaehrdung
    add constraint isr_brm_bedrohungskat_pk primary key ( gef_uid )
        using index enable;

alter table rk_main.isr_brm_gefaehrdung add constraint isr_brm_bedrohungskat_uk1 unique ( gef_titel )
    using index enable;

