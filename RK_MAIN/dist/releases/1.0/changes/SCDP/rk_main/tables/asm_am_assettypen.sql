-- liquibase formatted sql
-- changeset RK_MAIN:1774561694602 stripComments:false logicalFilePath:SCDP/rk_main/tables/asm_am_assettypen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/asm_am_assettypen.sql:null:d81331a6d902e2b703310b4886529061e4e24b4f:create

create table rk_main.asm_am_assettypen (
    ast_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ast_name         varchar2(200 char) not null enable,
    ast_beschreibung varchar2(200 char),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table rk_main.asm_am_assettypen
    add constraint asm_am_assettypen_pk primary key ( ast_uid )
        using index enable;

