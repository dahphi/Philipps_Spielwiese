-- liquibase formatted sql
-- changeset AM_MAIN:1774557121094 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_geraeteverbund.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_geraeteverbund.sql:null:cfc349a944723c40956340ff2116f87cb3a89d9c:create

create table am_main.hwas_geraeteverbund (
    gvb_uid         number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    gvb_bezeichnung varchar2(128 byte) not null enable,
    gvb_san         varchar2(64 byte),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char),
    gvb_verbundtyp  varchar2(64 byte),
    typ_uid         number
)
no inmemory;

alter table am_main.hwas_geraeteverbund
    add constraint hwas_geraeteverbund_pk primary key ( gvb_uid )
        using index enable;

alter table am_main.hwas_geraeteverbund add constraint hwas_geraeteverbund_uk1 unique ( gvb_bezeichnung )
    using index enable;

