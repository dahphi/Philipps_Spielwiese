-- liquibase formatted sql
-- changeset AM_MAIN:1774557121051 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_geraet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_geraet.sql:null:581d8211bf7b1ef3decd6b9a94719f111a15b7bc:create

create table am_main.hwas_geraet (
    grt_uid                     number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    grt_inventartnr             varchar2(32 byte),
    mdl_uid                     number,
    grt_assetname               varchar2(64 byte),
    grt_herstell_inbetrnhm_jahr number,
    rm_uid                      number,
    inserted                    date default sysdate not null enable,
    updated                     date,
    inserted_by                 varchar2(100 char),
    updated_by                  varchar2(100 char),
    grt_link_fremdsystem        varchar2(256 byte),
    grt_zielsystem              varchar2(32 byte),
    hst_uid                     number,
    grt_data_custodian          varchar2(64 byte),
    quellsystem_id              number,
    grt_quellsystem             varchar2(128 byte) default 'Hardware-DB',
    gvb_uid                     number,
    fkl_uid                     number,
    geb_uid                     number,
    status                      number
)
no inmemory;

create unique index am_main.hwas_geraet_uk2 on
    am_main.hwas_geraet (
        grt_assetname
    );

alter table am_main.hwas_geraet
    add constraint hwas_geraet_pk primary key ( grt_uid )
        using index enable;

alter table am_main.hwas_geraet
    add constraint hwas_geraet_uk1 unique ( grt_assetname )
        using index am_main.hwas_geraet_uk2 enable;

