-- liquibase formatted sql
-- changeset RK_MAIN:1774554921048 stripComments:false logicalFilePath:SCDP/rk_main/tables/asm_isr_assets_risiken.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/asm_isr_assets_risiken.sql:null:2d3a147eaadd9d291d7f819ad14d5e5c3148df1a:create

create table rk_main.asm_isr_assets_risiken (
    asri_uid    number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ass_uid     number not null enable,
    rsk_uid     number not null enable,
    inserted    date default sysdate not null enable,
    updated     date,
    inserted_by varchar2(100 char),
    updated_by  varchar2(100 char)
)
no inmemory;

alter table rk_main.asm_isr_assets_risiken
    add constraint asm_isr_assets_risken_pk primary key ( asri_uid )
        using index enable;

