-- liquibase formatted sql
-- changeset RK_MAIN:1774555713397 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_iso_27001_mapping.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_iso_27001_mapping.sql:null:a39c5f48d60e2d7066155a46d44258ac829d808b:create

create table rk_main.isr_iso_27001_mapping (
    i2c_map_uid     number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    i2c_2013_uid_fk number not null enable,
    i2c_2022_uid_fk number not null enable,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 byte),
    updated_by      varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_iso_27001_mapping
    add constraint isr_iso_27001_mapping_pk primary key ( i2c_map_uid )
        using index enable;

alter table rk_main.isr_iso_27001_mapping
    add constraint isr_iso_27001_mapping_uk1 unique ( i2c_2013_uid_fk,
                                                      i2c_2022_uid_fk )
        using index enable;

