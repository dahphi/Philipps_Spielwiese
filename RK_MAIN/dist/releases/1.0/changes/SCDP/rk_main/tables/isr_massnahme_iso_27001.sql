-- liquibase formatted sql
-- changeset RK_MAIN:1774561694925 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_massnahme_iso_27001.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_massnahme_iso_27001.sql:null:e85e59d531d17e93fc408c3b1cad78681abaf8a8:create

create table rk_main.isr_massnahme_iso_27001 (
    mi_id       number default on null to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    msn_uid     number not null enable,
    i2c_uid     number not null enable,
    inserted    date,
    inserted_by varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_massnahme_iso_27001
    add constraint massnahme_iso_controls_pk primary key ( mi_id )
        using index enable;

