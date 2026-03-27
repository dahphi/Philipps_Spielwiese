-- liquibase formatted sql
-- changeset AM_MAIN:1774600127328 stripComments:false logicalFilePath:am_main/am_main/tables/itwo_site.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/itwo_site.sql:null:06a481ff190b5929cf2cdbd9067c5344d594e4f2:create

create table am_main.itwo_site (
    obj_id  number not null enable,
    site    varchar2(64 byte),
    plz     varchar2(5 byte),
    stadt   varchar2(64 byte),
    strasse varchar2(64 byte),
    haus_nr varchar2(16 byte)
)
no inmemory;

alter table am_main.itwo_site
    add constraint itwo_site_pk primary key ( obj_id )
        using index enable;

alter table am_main.itwo_site add constraint itwo_site_uk1 unique ( site )
    using index enable;

