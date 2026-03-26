-- liquibase formatted sql
-- changeset AM_MAIN:1774557121642 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_test_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_test_import.sql:null:ee1bcceed640561175232aa83f6c49f87e9c6dd5:create

create table am_main.hwas_test_import (
    "PRIMÄRKEY"                       number(38, 0),
    lieferant                         number(38, 0),
    name1                             varchar2(128 byte),
    bestellung                        number(38, 0),
    bestellposition                   varchar2(26 byte),
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
    kontierungsobjekt                 varchar2(128 byte),
    verantwortlicher                  varchar2(26 byte),
    verantwortlicher_kostenstelle     varchar2(26 byte),
    sachkonto                         number(38, 0),
    auftrag                           number(38, 0),
    splitwert                         varchar2(26 byte)
)
no inmemory;

