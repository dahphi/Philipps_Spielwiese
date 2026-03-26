-- liquibase formatted sql
-- changeset AM_MAIN:1774556573588 stripComments:false logicalFilePath:SCDP/am_main/tables/hwdb_hosts.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwdb_hosts.sql:null:c88988e512cbb2757f0780a67e9861d11e8ccc8f:create

create table am_main.hwdb_hosts (
    hostname        varchar2(128 byte),
    hersteller      varchar2(64 byte),
    modell          varchar2(128 byte),
    funktionsklasse varchar2(64 byte),
    location        varchar2(128 byte),
    raum            varchar2(64 byte),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    valid_to        date,
    status          number
)
no inmemory;

