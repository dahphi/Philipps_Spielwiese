-- liquibase formatted sql
-- changeset AM_MAIN:1774600124509 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_funktionsklasse.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_funktionsklasse.sql:null:e4b6482787056955075bf4c0e1384ab7ca9242d6:create

create table am_main.hwas_funktionsklasse (
    fkl_uid             number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    fkl_bezeichnung     varchar2(128 byte) not null enable,
    fkl_beschreibung    varchar2(4000 byte),
    inserted            date default sysdate not null enable,
    updated             date,
    inserted_by         varchar2(100 char),
    updated_by          varchar2(100 char),
    tkt_uid             number,
    fkl_kritis_relevant number default 0,
    ruf_uid             number
)
no inmemory;

alter table am_main.hwas_funktionsklasse
    add constraint hwas_funktionsklasse_pk primary key ( fkl_uid )
        using index enable;

alter table am_main.hwas_funktionsklasse add constraint hwas_funktionsklasse_uk1 unique ( fkl_bezeichnung )
    using index enable;

