-- liquibase formatted sql
-- changeset RK_MAIN:1774561694725 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_brm_elem_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_brm_elem_gefaehrdung.sql:null:28e27453b66c01f75355a9f3c99f14135a234512:create

create table rk_main.isr_brm_elem_gefaehrdung (
    ege_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ege_titel        varchar2(64 byte) not null enable,
    ege_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char),
    aktiv            number default 1 not null enable
)
no inmemory;

alter table rk_main.isr_brm_elem_gefaehrdung
    add constraint isr_brm_elem_gefaehrdung_pk primary key ( ege_uid )
        using index enable;

alter table rk_main.isr_brm_elem_gefaehrdung add constraint isr_brm_elem_gefaehrdung_uk1 unique ( ege_titel )
    using index enable;

