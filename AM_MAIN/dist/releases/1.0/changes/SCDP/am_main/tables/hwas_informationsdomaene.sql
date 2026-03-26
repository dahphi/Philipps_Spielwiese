-- liquibase formatted sql
-- changeset AM_MAIN:1774556573012 stripComments:false logicalFilePath:SCDP/am_main/tables/hwas_informationsdomaene.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_informationsdomaene.sql:null:76a4c746fa358d0556b146195e846d46acb7f0b8:create

create table am_main.hwas_informationsdomaene (
    dom_uid      number default to_number(sys_guid(), 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx') not null enable,
    domaene      varchar2(64 byte),
    beschreibung varchar2(4000 byte),
    inserted     date,
    updated      date,
    inserted_by  varchar2(100 byte),
    updated_by   varchar2(100 byte)
)
no inmemory;

alter table am_main.hwas_informationsdomaene
    add constraint dom_uid_pk primary key ( dom_uid )
        using index enable;

