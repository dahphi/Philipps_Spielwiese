-- liquibase formatted sql
-- changeset AM_MAIN:1774557121547 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_prozessstufe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_prozessstufe.sql:null:210425f450d101d466eb191012f740f170e12c2b:create

create table am_main.hwas_prozessstufe (
    przs_uid        number default to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') not null enable,
    prz_uid         number,
    parent_przs_uid number,
    name            varchar2(100 byte) not null enable,
    beschreibung    varchar2(4000 byte),
    inserted        date default sysdate not null enable,
    inserted_by     varchar2(100 byte) not null enable,
    updated         date,
    updated_by      varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_prozessstufe
    add constraint przs_uid_pk primary key ( przs_uid )
        using index enable;

