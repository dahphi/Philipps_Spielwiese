-- liquibase formatted sql
-- changeset AM_MAIN:1774556573794 stripComments:false logicalFilePath:SCDP/am_main/tables/sap_lieferanten_kreditoren_nr_backup.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_lieferanten_kreditoren_nr_backup.sql:null:b8a86ec90cbcaedb18f730070a69928207fbb473:create

create table am_main.sap_lieferanten_kreditoren_nr_backup (
    likr_uid       number not null enable,
    lie_uid_fk     number not null enable,
    kred_nr_sap    number not null enable,
    inserted       date not null enable,
    inserted_by    varchar2(128 byte) not null enable,
    kred_nr_sap_vc varchar2(10 byte)
)
no inmemory;

