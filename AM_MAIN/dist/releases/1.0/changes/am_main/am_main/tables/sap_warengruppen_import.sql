-- liquibase formatted sql
-- changeset AM_MAIN:1774600127916 stripComments:false logicalFilePath:am_main/am_main/tables/sap_warengruppen_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_warengruppen_import.sql:null:7fe70ed9e95eed1d0ab1c188c7cb57ce7643c365:create

create table am_main.sap_warengruppen_import (
    sap_id                    number,
    warengruppenbezeichnung   varchar2(200 byte),
    warengruppenbezeichnung_2 varchar2(200 byte),
    inserted                  date,
    inserted_by               varchar2(20 byte),
    updated                   date,
    updated_by                varchar2(20 byte)
)
no inmemory;

