-- liquibase formatted sql
-- changeset RK_MAIN:1774554921257 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_iso_27001_anhang_a.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_iso_27001_anhang_a.sql:null:12f67de1d94223d85a746cb4a5a3f47b67e3269c:create

create table rk_main.isr_iso_27001_anhang_a (
    i2a_uid    number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    i2a_nummer number,
    i2a_titel  varchar2(256 byte)
)
no inmemory;

alter table rk_main.isr_iso_27001_anhang_a
    add constraint isr_iso_27001_anhang_a_pk primary key ( i2a_uid )
        using index enable;

alter table rk_main.isr_iso_27001_anhang_a add constraint isr_iso_27001_anhang_a_uk1 unique ( i2a_nummer )
    using index enable;

alter table rk_main.isr_iso_27001_anhang_a add constraint isr_iso_27001_anhang_a_uk2 unique ( i2a_titel )
    using index enable;

