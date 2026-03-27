-- liquibase formatted sql
-- changeset AM_MAIN:1774600125038 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_hersteller.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_hersteller.sql:null:e4ceea891957aff63a3a495c88e517f3c83f1998:create

create table am_main.hwas_hersteller (
    hst_uid          number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    hst_bezeichnung  varchar2(32 byte) not null enable,
    hst_beschreibung varchar2(4000 byte),
    hst_url          varchar2(256 byte),
    inserted         date default sysdate not null enable,
    updated          date,
    inserted_by      varchar2(100 char),
    updated_by       varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_hersteller
    add constraint hwas_hersteller_pk primary key ( hst_uid )
        using index enable;

alter table am_main.hwas_hersteller add constraint hwas_hersteller_uk1 unique ( hst_bezeichnung )
    using index enable;

