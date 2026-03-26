-- liquibase formatted sql
-- changeset AM_MAIN:1774556573191 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_produkt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_produkt.sql:null:3cd30a51d9e15c344c7cd634ba4aa8f65ae0eb60:create

create table am_main.hwas_produkt (
    prod_uid                  number default to_number(substr(
        rawtohex(sys_guid()),
        1,
        30
    ),
          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name                      varchar2(400 char) not null enable,
    beschreibung              varchar2(4000 char),
    produktstatus             number,
    leistungsbeschreibung_url varchar2(500 char),
    prom_uid_fk               number,
    prod_owner                varchar2(200 byte),
    gesku_uid_fk              number,
    tech_ansprechpartner      varchar2(200 byte)
)
no inmemory;

alter table am_main.hwas_produkt
    add constraint pk_hwas_produkt primary key ( prod_uid )
        using index enable;

