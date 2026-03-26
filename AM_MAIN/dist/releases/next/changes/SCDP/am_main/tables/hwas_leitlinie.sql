-- liquibase formatted sql
-- changeset AM_MAIN:1774557121289 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_leitlinie.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_leitlinie.sql:null:80a21deeb55da2d45231e10bea2801b491cad628:create

create table am_main.hwas_leitlinie (
    ll_uid             number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    ll_titel           varchar2(128 byte),
    ll_beschreibung    varchar2(4000 byte),
    ll_ansprechpartner varchar2(20 byte),
    inserted           date default sysdate not null enable,
    updated            date,
    inserted_by        varchar2(100 char),
    updated_by         varchar2(100 char)
)
no inmemory;

alter table am_main.hwas_leitlinie
    add constraint hwas_leitlinie_pk primary key ( ll_uid )
        using index enable;

