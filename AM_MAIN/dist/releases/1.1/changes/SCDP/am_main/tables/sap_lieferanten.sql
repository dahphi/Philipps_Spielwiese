-- liquibase formatted sql
-- changeset AM_MAIN:1774557222512 stripComments:false logicalFilePath:SCDP/am_main/tables/sap_lieferanten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_lieferanten.sql:null:6d30324473a8aa0d36414ebb7ec0fe78891bfb97:create

create table am_main.sap_lieferanten (
    lie_uid                   number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    bezeichnung               varchar2(255 byte),
    inserted                  date,
    inserted_by               varchar2(50 byte),
    updated                   date,
    updated_by                varchar2(50 byte),
    kreditoren_nr             varchar2(50 byte),
    link_kooperationsfreigabe varchar2(255 byte),
    bemerkung                 varchar2(400 byte),
    gek_lfd_nr                number
)
no inmemory;

alter table am_main.sap_lieferanten
    add constraint pk_sap_lieferanten primary key ( lie_uid )
        using index enable;

