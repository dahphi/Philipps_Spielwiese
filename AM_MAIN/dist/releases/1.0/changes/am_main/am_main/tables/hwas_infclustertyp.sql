-- liquibase formatted sql
-- changeset AM_MAIN:1774600125158 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_infclustertyp.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_infclustertyp.sql:null:d722c57d9a293ba64c4bc42671c2d66179bd3d63:create

create table am_main.hwas_infclustertyp (
    ict_uid      number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    typ          varchar2(64 byte),
    beschreibung varchar2(4000 byte),
    inserted     date,
    updated      date,
    inserted_by  varchar2(100 byte),
    updated_by   varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_infclustertyp
    add constraint ict_uid_pk primary key ( ict_uid )
        using index enable;

