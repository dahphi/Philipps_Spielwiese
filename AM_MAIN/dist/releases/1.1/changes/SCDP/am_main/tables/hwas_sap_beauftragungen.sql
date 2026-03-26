-- liquibase formatted sql
-- changeset AM_MAIN:1774557121627 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_sap_beauftragungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_sap_beauftragungen.sql:null:e4e73a5f76dd6b227cadfb6e59b8934f4f220c0b:create

create table am_main.hwas_sap_beauftragungen (
    sap_bea_guid                     number not null enable,
    primarykey_sap                   varchar2(200 byte),
    lieferant                        varchar2(200 byte),
    name1                            varchar2(200 byte),
    bestellung                       varchar2(200 byte),
    bestellposition                  varchar2(200 byte),
    lieferdatum_position             varchar2(200 byte),
    warengruppe                      varchar2(200 byte),
    bezeichnung_warengruppe          varchar2(200 byte),
    kurztext_position                varchar2(200 byte),
    buchungskreis                    varchar2(200 byte),
    ersteller                        varchar2(200 byte),
    vorname                          varchar2(200 byte),
    nachname                         varchar2(200 byte),
    erstellungsdatum                 varchar2(200 byte),
    einkaeufergruppe                 varchar2(200 byte),
    bezeichnung_einkaeufergruppe     varchar2(200 byte),
    anforderer                       varchar2(200 byte),
    nettobestellwert_bestellwaehrung varchar2(200 byte),
    waehrung                         varchar2(200 byte),
    kontierungstyp                   varchar2(200 byte),
    kontierungsobjekt                varchar2(200 byte),
    verantwortlicher                 varchar2(200 byte),
    verantwortliche_kostenstelle     varchar2(200 byte),
    sachkonto                        varchar2(200 byte),
    auftrag                          varchar2(200 byte),
    splitwert                        varchar2(200 byte)
)
no inmemory;

