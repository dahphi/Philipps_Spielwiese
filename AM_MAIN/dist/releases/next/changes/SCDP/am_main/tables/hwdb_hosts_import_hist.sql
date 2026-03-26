-- liquibase formatted sql
-- changeset AM_MAIN:1774556573600 stripComments:false logicalFilePath:SCDP/am_main/tables/hwdb_hosts_import_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwdb_hosts_import_hist.sql:null:cebb6e62bf060ffe8bdb44e89f83b2e802d09ebe:create

create table am_main.hwdb_hosts_import_hist (
    hwdb_imp_uid     number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    hostname         varchar2(128 byte),
    hersteller       varchar2(128 byte),
    modell           varchar2(128 byte),
    funktionsklasse  varchar2(128 byte),
    location         varchar2(128 byte),
    raum             varchar2(128 byte),
    inserted         date,
    inserted_by      varchar2(128 byte),
    system_kommentar varchar2(128 byte)
)
no inmemory;

alter table am_main.hwdb_hosts_import_hist
    add constraint hwdb_imp_uid_pk primary key ( hwdb_imp_uid )
        using index enable;

