-- liquibase formatted sql
-- changeset RK_MAIN:1774555713176 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_auswirkung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_auswirkung.sql:null:6d94a60dc3d5520a952193c69565af1a24b66859:create

create table rk_main.isr_auswirkung (
    auw_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    auw_bezeichnung varchar2(64 byte) not null enable,
    auw_wert        number not null enable,
    auw_kriterien   varchar2(4000 byte),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table rk_main.isr_auswirkung
    add constraint isr_auswirkung_pk primary key ( auw_uid )
        using index enable;

alter table rk_main.isr_auswirkung add constraint isr_auswirkung_uk1 unique ( auw_bezeichnung )
    using index enable;

