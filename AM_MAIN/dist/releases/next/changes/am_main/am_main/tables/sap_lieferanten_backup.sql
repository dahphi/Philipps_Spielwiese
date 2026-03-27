-- liquibase formatted sql
-- changeset AM_MAIN:1774600127773 stripComments:false logicalFilePath:am_main/am_main/tables/sap_lieferanten_backup.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_lieferanten_backup.sql:null:8915ed2680d90f9b7507a18f4a13eb29d31867ad:create

create table am_main.sap_lieferanten_backup (
    lie_uid                   number not null enable,
    bezeichnung               varchar2(255 byte),
    inserted                  date,
    inserted_by               varchar2(50 byte),
    updated                   date,
    updated_by                varchar2(50 byte),
    kreditoren_nr             varchar2(50 byte),
    link_kooperationsfreigabe varchar2(255 byte)
)
no inmemory;

