-- liquibase formatted sql
-- changeset AM_MAIN:1774557120701 stripComments:false logicalFilePath:SCDP/am_main/tables/bic_import_anwendungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bic_import_anwendungen.sql:null:914b3e06412a34c582b692158c9c21f9ee4f6c85:create

create table am_main.bic_import_anwendungen (
    guid   varchar2(200 byte),
    quelle varchar2(200 byte),
    name   varchar2(200 byte)
)
no inmemory;

