-- liquibase formatted sql
-- changeset AM_MAIN:1774600127261 stripComments:false logicalFilePath:am_main/am_main/tables/itwo_raum.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/itwo_raum.sql:null:c033f58e4e725338f247abfb1c83418860570591:create

create table am_main.itwo_raum (
    raum         varchar2(40 byte) not null enable,
    site         varchar2(64 byte),
    standortpfad varchar2(128 byte)
)
no inmemory;

