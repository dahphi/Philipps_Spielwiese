-- liquibase formatted sql
-- changeset AM_MAIN:1774600127381 stripComments:false logicalFilePath:am_main/am_main/tables/itwo_site_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/itwo_site_import_hist.sql:null:fa4d213cc7132495a65aef240be53e683a2db57e:create

create table am_main.itwo_site_import_hist (
    itwo_site_uid    number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    obj_id           number,
    site             varchar2(64 byte),
    plz              varchar2(5 byte),
    stadt            varchar2(64 byte),
    strasse          varchar2(64 byte),
    haus_nr          varchar2(16 byte),
    inserted         date,
    inserted_by      varchar2(128 byte),
    system_kommentar varchar2(128 byte)
)
no inmemory;

alter table am_main.itwo_site_import_hist
    add constraint itwo_site_uid_pk primary key ( itwo_site_uid )
        using index enable;

