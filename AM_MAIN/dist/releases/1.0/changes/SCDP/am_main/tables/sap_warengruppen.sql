-- liquibase formatted sql
-- changeset AM_MAIN:1774556573803 stripComments:false logicalFilePath:SCDP/am_main/tables/sap_warengruppen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_warengruppen.sql:null:eb6eb41a1770eab6dbb2483005e4c41b3cd850c6:create

create table am_main.sap_warengruppen (
    war_uid                   number,
    sap_id                    number,
    warengruppenbezeichnung   varchar2(200 byte),
    warengruppenbezeichnung_2 varchar2(200 byte),
    is_relevant               number,
    bemerkung                 varchar2(400 byte),
    inserted                  date,
    inserted_by               varchar2(20 byte),
    updated                   date,
    updated_by                varchar2(20 byte),
    capex_opex                varchar2(200 byte)
)
no inmemory;

