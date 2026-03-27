-- liquibase formatted sql
-- changeset AM_MAIN:1774600125125 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_import_test2.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_import_test2.sql:null:db72c117bdd8e5361c4fc9bb6af510063d82d5d0:create

create table am_main.hwas_import_test2 (
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
    "NETTOBESTELLWERT_BESTELLWÄHRUNG" number(38, 0),
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

