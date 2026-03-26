-- liquibase formatted sql
-- changeset AM_MAIN:1774556573158 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_netzebene.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_netzebene.sql:null:14fc72a512af124365a70c943b920a27ba1e9c9b:create

create table am_main.hwas_netzebene (
    ne_uid          number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ne_bezeichnung  varchar2(64 byte) not null enable,
    ne_beschreibung varchar2(4000 byte),
    inserted        date default sysdate not null enable,
    updated         date,
    inserted_by     varchar2(100 char),
    updated_by      varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_netzebene
    add constraint hwas_netzebene_pk primary key ( ne_uid )
        using index enable;

alter table am_main.hwas_netzebene add constraint hwas_netzebene_uk1 unique ( ne_bezeichnung )
    using index enable;

