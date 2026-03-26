-- liquibase formatted sql
-- changeset RK_MAIN:1774555713734 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_oam_umsetzungsstatus.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_oam_umsetzungsstatus.sql:null:665c8ba77677a7ae7c9bbf4451e8f378dec2d6ae:create

create table rk_main.isr_oam_umsetzungsstatus (
    uss_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    uss_bezeichnung  varchar2(64 byte) not null enable,
    uss_beschreibung varchar2(4000 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_oam_umsetzungsstatus
    add constraint isr_oam_umsetzungsstatus_pk primary key ( uss_uid )
        using index enable;

alter table rk_main.isr_oam_umsetzungsstatus add constraint isr_oam_umsetzungsstatus_uk1 unique ( uss_bezeichnung )
    using index enable;

