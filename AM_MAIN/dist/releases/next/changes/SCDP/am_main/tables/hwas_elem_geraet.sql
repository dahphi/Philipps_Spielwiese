-- liquibase formatted sql
-- changeset AM_MAIN:1774557120965 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_elem_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_elem_geraet.sql:null:23c99c5144546bb891878662db7c9af0a897bc23:create

create table am_main.hwas_elem_geraet (
    elg_uid                     number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    mdl_uid                     number,
    elg_geraetename             varchar2(256 byte) not null enable,
    elg_herstell_inbetrnhm_jahr number,
    rm_uid                      number,
    inserted                    date not null enable,
    updated                     date,
    inserted_by                 varchar2(100 char),
    updated_by                  varchar2(100 char),
    elg_link_fremdsystem        varchar2(256 byte),
    elg_zielsystem              varchar2(32 byte),
    hst_uid                     number not null enable,
    elg_data_custodian          varchar2(64 byte),
    quellsystem_id              number,
    elg_quellsystem             varchar2(128 byte),
    gvb_uid                     number,
    fkl_uid                     number,
    elg_anschaffung_dat         date,
    elg_inventur_dat            date,
    elg_kommentar               varchar2(4000 byte),
    geb_uid                     number,
    status                      number
)
no inmemory;

create unique index am_main.hwas_elem_geraet_uk2 on
    am_main.hwas_elem_geraet (
        elg_geraetename
    );

create unique index am_main.hwas_elem_geraet_pk1 on
    am_main.hwas_elem_geraet (
        elg_uid
    );

alter table am_main.hwas_elem_geraet
    add constraint hwas_elem_geraet_pk
        primary key ( elg_uid )
            using index am_main.hwas_elem_geraet_pk1 enable;

alter table am_main.hwas_elem_geraet
    add constraint hwas_elem_geraet_uk1 unique ( elg_geraetename )
        using index am_main.hwas_elem_geraet_uk2 enable;

