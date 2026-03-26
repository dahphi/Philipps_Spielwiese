-- liquibase formatted sql
-- changeset RK_MAIN:1774554921101 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_assettypen_gefaehrdungkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_assettypen_gefaehrdungkat.sql:null:95d281eb9b86da329f3f37aed6ba5b6e7cea5229:create

create table rk_main.isr_assettypen_gefaehrdungkat (
    atgk_uid    number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ast_uid     number not null enable,
    gfk_uid     number not null enable,
    inserted    date default sysdate not null enable,
    updated     date,
    inserted_by varchar2(100 byte),
    updated_by  varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_assettypen_gefaehrdungkat
    add constraint isr_atgk_pk primary key ( atgk_uid )
        using index enable;

