-- liquibase formatted sql
-- changeset RK_MAIN:1774554921062 stripComments:false logicalFilePath:SCDP/rk_main/tables/asm_isr_assets_risiken_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/asm_isr_assets_risiken_hist.sql:null:22d7b5c59a7b78e7db47341e251faca48a542dcb:create

create table rk_main.asm_isr_assets_risiken_hist (
    asrih_uid         number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    asri_uid          number,
    ass_uid           number,
    rsk_uid           number,
    inserted          date,
    inserted_by       varchar2(255 byte),
    updated_by        varchar2(255 byte),
    updated           date,
    insert_info       varchar2(400 byte),
    asrih_inserted    date,
    asrih_inserted_by varchar2(200 byte)
)
no inmemory;

alter table rk_main.asm_isr_assets_risiken_hist
    add constraint asrih_uid_pk primary key ( asrih_uid )
        using index enable;

