-- liquibase formatted sql
-- changeset AM_MAIN:1774600124606 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_gebaeude.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_gebaeude.sql:null:9560a1902d8f893b25b680e6450b59f38afe28f2:create

create table am_main.hwas_gebaeude (
    geb_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    geb_bezeichnung     varchar2(128 byte) not null enable,
    geb_beschreibung    varchar2(4000 byte),
    geb_strasse_hnr     varchar2(128 byte),
    geb_adresszusatz    varchar2(128 byte),
    geb_plz             varchar2(8 byte),
    geb_ort             varchar2(128 byte),
    inserted            date default sysdate not null enable,
    updated             date,
    inserted_by         varchar2(100 char),
    updated_by          varchar2(100 char),
    geb_kritis_relevant number,
    site                varchar2(128 byte),
    obj_id              varchar2(128 byte),
    data_custodian      varchar2(64 byte)
)
no inmemory;

alter table am_main.hwas_gebaeude
    add constraint hwas_gebaeude_pk primary key ( geb_uid )
        using index enable;

alter table am_main.hwas_gebaeude add constraint hwas_gebaeude_uk1 unique ( site )
    using index enable;

