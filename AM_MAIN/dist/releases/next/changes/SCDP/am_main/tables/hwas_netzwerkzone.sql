-- liquibase formatted sql
-- changeset AM_MAIN:1774557121383 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_netzwerkzone.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_netzwerkzone.sql:null:9cb775fff05f41dcf22ae7face855158cf4030c8:create

create table am_main.hwas_netzwerkzone (
    nzone_uid          number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    nzone_bezeichnung  varchar2(255 byte),
    nzone_beschreibung varchar2(400 byte),
    inserted           date,
    updated            date,
    inserted_by        varchar2(100 byte),
    updated_by         varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_netzwerkzone
    add constraint nzone_uid_pk primary key ( nzone_uid )
        using index enable;

