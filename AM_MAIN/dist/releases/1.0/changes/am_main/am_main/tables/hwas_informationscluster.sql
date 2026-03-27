-- liquibase formatted sql
-- changeset AM_MAIN:1774600125224 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_informationscluster.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_informationscluster.sql:null:440899b60dfc04a2c2638d3bd51b8f1d314afc00:create

create table am_main.hwas_informationscluster (
    incl_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    incl_bezeichnung  varchar2(128 byte) not null enable,
    incl_beschreibung varchar2(4000 byte),
    vet_lfd_nr        number,
    vef_lfd_nr        number,
    int_lfd_nr        number,
    aut_lfd_nr        number,
    inserted          date default sysdate not null enable,
    updated           date,
    inserted_by       varchar2(100 char),
    updated_by        varchar2(100 char),
    data_owner        varchar2(200 byte),
    dom_uid_fk        varchar2(400 byte),
    incl_typ          varchar2(200 byte)
)
no inmemory;

create unique index am_main.hwas_informationscluster_pk on
    am_main.hwas_informationscluster (
        incl_uid
    );

create unique index am_main.hwas_informationscluster_uk1 on
    am_main.hwas_informationscluster (
        incl_bezeichnung
    );

alter table am_main.hwas_informationscluster
    add constraint hwas_informationscluster_pk
        primary key ( incl_uid )
            using index am_main.hwas_informationscluster_pk enable;

alter table am_main.hwas_informationscluster
    add constraint hwas_informationscluster_uk1 unique ( incl_bezeichnung )
        using index am_main.hwas_informationscluster_uk1 enable;

