-- liquibase formatted sql
-- changeset AM_MAIN:1774557221248 stripComments:false logicalFilePath:SCDP/am_main/tables/bic_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bic_import.sql:null:b150a319307dfa9dd2bc854b721c89ae5e9857cc:create

create table am_main.bic_import (
    unknown      varchar2(2000 byte),
    guid         varchar2(2000 byte),
    typname      varchar2(2000 byte),
    pfad1        varchar2(2000 byte),
    pfad2        varchar2(2000 byte),
    pfad3        varchar2(2000 byte),
    pfad4        varchar2(2000 byte),
    pfad5        varchar2(2000 byte),
    pfad6        varchar2(2000 byte),
    prozessname  varchar2(2000 byte),
    bereich      varchar2(2000 byte),
    prozessowner varchar2(2000 byte),
    import_datum date
)
no inmemory;

