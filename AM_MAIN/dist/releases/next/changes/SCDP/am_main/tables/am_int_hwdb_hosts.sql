-- liquibase formatted sql
-- changeset AM_MAIN:1774557120684 stripComments:false logicalFilePath:SCDP/am_main/tables/am_int_hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/am_int_hwdb_hosts.sql:null:1d0f52a8932271c9795100ac390d43cc573b66d7:create

create table am_main.am_int_hwdb_hosts (
    hostname        varchar2(128 byte),
    hersteller      varchar2(64 byte),
    modell          varchar2(128 byte),
    funktionsklasse varchar2(64 byte),
    location        varchar2(64 byte),
    raum            varchar2(64 byte)
)
no inmemory;

