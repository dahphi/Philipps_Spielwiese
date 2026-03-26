-- liquibase formatted sql
-- changeset AM_MAIN:1774557121820 stripComments:false logicalFilePath:SCDP/am_main/tables/itwo_raum_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/itwo_raum_import_hist.sql:null:3d2330b84f842b4d68e523b8c409b8ccb62e0b5b:create

create table am_main.itwo_raum_import_hist (
    itwo_raum_uid    number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    raum             varchar2(40 byte),
    site             varchar2(64 byte),
    standortpfad     varchar2(128 byte),
    inserted         date,
    inserted_by      varchar2(128 byte),
    system_kommentar varchar2(128 byte)
)
no inmemory;

alter table am_main.itwo_raum_import_hist
    add constraint itwo_raum_uid_pk primary key ( itwo_raum_uid )
        using index enable;

