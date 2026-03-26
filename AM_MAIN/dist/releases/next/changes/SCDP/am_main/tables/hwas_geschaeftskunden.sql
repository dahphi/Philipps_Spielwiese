-- liquibase formatted sql
-- changeset AM_MAIN:1774557221680 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_geschaeftskunden.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_geschaeftskunden.sql:null:0f1881a54fd31ab8eb209e7feda0f9016d4c7da2:create

create table am_main.hwas_geschaeftskunden (
    gesku_uid                         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    name                              varchar2(200 char) not null enable,
    hubspot_datensatz_id              varchar2(100 char),
    anspa_info_sicherheitsvorfaelle   varchar2(200 char),
    anspa_info_sicherheit             varchar2(200 char),
    anspa_netcologne_geschaeftskunden varchar2(200 char),
    confluence_seite                  varchar2(400 char),
    inserted                          date default sysdate,
    inserted_by                       varchar2(100 char),
    updated                           date,
    updated_by                        varchar2(100 char),
    bsi_it_grundschutz_relevanz       number default 0 not null enable,
    dora_relevant                     number,
    kundennr_siebel                   number,
    ansprech_mail                     varchar2(50 byte),
    ansprech_telefon                  varchar2(50 byte),
    kritis_relevant                   number
)
no inmemory;

alter table am_main.hwas_geschaeftskunden
    add constraint pk_hwas_geschaeftskunden primary key ( gesku_uid )
        using index enable;

alter table am_main.hwas_geschaeftskunden add constraint siebel_geschaeftskunden_uk1 unique ( kundennr_siebel )
    using index enable;

alter table am_main.hwas_geschaeftskunden add constraint uc_geschaeftskunden_hubspot_id unique ( hubspot_datensatz_id )
    using index enable;

alter table am_main.hwas_geschaeftskunden add constraint uq_hwas_geschaeftskunden_name unique ( name )
    using index enable;

