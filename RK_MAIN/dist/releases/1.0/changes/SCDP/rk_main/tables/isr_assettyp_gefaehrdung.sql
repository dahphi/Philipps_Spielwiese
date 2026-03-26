-- liquibase formatted sql
-- changeset RK_MAIN:1774561694675 stripComments:false logicalFilePath:SCDP/rk_main/tables/isr_assettyp_gefaehrdung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/tables/isr_assettyp_gefaehrdung.sql:null:630e08f09ea54c50f5f68fdda8da3d1fcb8daf2d:create

create table rk_main.isr_assettyp_gefaehrdung (
    atg_uid     number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    ast_uid     number,
    gef_uid     number,
    inserted    date,
    updated     date,
    inserted_by varchar2(100 byte),
    updated_by  varchar2(100 byte)
)
no inmemory;

alter table rk_main.isr_assettyp_gefaehrdung
    add constraint atg_uid_pk primary key ( atg_uid )
        using index enable;

