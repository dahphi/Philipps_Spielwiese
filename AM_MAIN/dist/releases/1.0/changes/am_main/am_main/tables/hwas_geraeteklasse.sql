-- liquibase formatted sql
-- changeset AM_MAIN:1774600124788 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_geraeteklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_geraeteklasse.sql:null:4ffd15aa6688338c06eb85370d71a63f6540808f:create

create table am_main.hwas_geraeteklasse (
    gkl_uid         number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    gkl_bezeichnung varchar2(32 byte) not null enable,
    gkl_highlights  varchar2(4000 byte),
    gkl_art         varchar2(16 byte),
    tkt_uid         number,
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_geraeteklasse
    add constraint hwas_geraetegattung_pk primary key ( gkl_uid )
        using index enable;

alter table am_main.hwas_geraeteklasse add constraint hwas_geraetegattung_uk1 unique ( gkl_bezeichnung )
    using index enable;

