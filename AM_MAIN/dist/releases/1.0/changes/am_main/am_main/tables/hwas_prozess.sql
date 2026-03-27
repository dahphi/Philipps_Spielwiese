-- liquibase formatted sql
-- changeset AM_MAIN:1774600126225 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_prozess.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozess.sql:null:ab2c289591e87a20737f43d450313f658f65250b:create

create table am_main.hwas_prozess (
    przp_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    przs_uid             number not null enable,
    name                 varchar2(200 byte) not null enable,
    beschreibung         varchar2(4000 byte),
    inserted             date default sysdate not null enable,
    inserted_by          varchar2(100 byte) not null enable,
    updated              date,
    updated_by           varchar2(100 byte),
    link_zum_fremdsystem varchar2(400 byte),
    kritis_relevant      varchar2(20 byte),
    prozess_owner        varchar2(100 byte),
    gek_lfd_nr_fk        number,
    fbk_uid_fk           number,
    prozess_owner_bic    varchar2(400 byte),
    anwendungen_bic      varchar2(4000 byte),
    guid_bic             varchar2(400 byte),
    lebenszyklus         number
)
no inmemory;

create unique index am_main.przp_uid_pk on
    am_main.hwas_prozess (
        przp_uid
    );

alter table am_main.hwas_prozess
    add constraint przp_uid_pk
        primary key ( przp_uid )
            using index am_main.przp_uid_pk enable;

