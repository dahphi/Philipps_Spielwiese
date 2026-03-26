-- liquibase formatted sql
-- changeset AM_MAIN:1774556572557 stripComments:false logicalFilePath:SCDP/am_main/tables/bic_import_test_februar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bic_import_test_februar.sql:null:12146762bb01e4c15e2e6ca8a1e616b40a95dfd0:create

create table am_main.bic_import_test_februar (
    typ     varchar2(2000 byte),
    guid    varchar2(2000 byte),
    typname varchar2(2000 byte),
    quelle  varchar2(2000 byte),
    pfad    varchar2(2000 byte),
    at_name varchar2(2000 byte)
)
no inmemory;

