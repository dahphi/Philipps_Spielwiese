-- liquibase formatted sql
-- changeset AM_MAIN:1774557121905 stripComments:false logicalFilePath:SCDP/am_main/tables/sap_import_1712_2025.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_import_1712_2025.sql:null:0843343b8ff16229a0ed52b6bbfe63cbe9dc2c84:create

create table am_main.sap_import_1712_2025 (
    "PRIMÄRKEY"                       number(38, 0),
    lieferant                         number(38, 0),
    name1                             varchar2(128 byte),
    bestellung                        number(38, 0),
    bestellposition                   number(38, 0),
    lieferdatum_position              number(38, 0),
    warengruppe                       number(38, 0),
    bezeichnung_warengruppe           varchar2(26 byte),
    kurztext_position                 varchar2(128 byte),
    buchungskreis                     number(38, 0),
    ersteller                         varchar2(26 byte),
    vorname                           varchar2(26 byte),
    nachname                          varchar2(26 byte),
    erstellungsdatum                  number(38, 0),
    "EINKÄUFERGRUPPE"                 number(38, 0),
    "BEZEICHNUNG_EINKÄUFERGRUPPE"     varchar2(26 byte),
    anforderer                        varchar2(26 byte),
    "NETTOBESTELLWERT_BESTELLWÄHRUNG" varchar2(26 byte),
    "WÄHRUNG"                         varchar2(26 byte),
    kontierungstyp                    varchar2(26 byte),
    kontierungsobjekt                 number(38, 0),
    verantwortlicher                  varchar2(26 byte),
    verantwortlicher_kostenstelle     varchar2(26 byte),
    sachkonto                         varchar2(26 byte),
    auftrag                           varchar2(26 byte),
    splitwert                         varchar2(26 byte)
)
no inmemory;

