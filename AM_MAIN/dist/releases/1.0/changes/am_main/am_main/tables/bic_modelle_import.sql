-- liquibase formatted sql
-- changeset AM_MAIN:1774600123458 stripComments:false logicalFilePath:am_main/am_main/tables/bic_modelle_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bic_modelle_import.sql:null:90a86e6ad10bef42689da79a6f00fa8fca1188ca:create

create table am_main.bic_modelle_import (
    at_name  varchar2(20 byte),
    bic_guid varchar2(200 byte),
    pfad     varchar2(400 byte),
    typname  varchar2(200 byte),
    name     varchar2(200 byte)
)
no inmemory;

