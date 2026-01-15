-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991245 stripComments:false logicalFilePath:develop/roma_main/tables/ftth_glascontainer_produkte.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/ftth_glascontainer_produkte.sql:null:5e9e58b6c49365d552ec601ffd36e89b6874bfba:create

create table roma_main.ftth_glascontainer_produkte (
    template_id              varchar2(100 byte) not null enable,
    aktion                   varchar2(30 byte) not null enable,
    name                     varchar2(100 byte) not null enable,
    bandbreite               number,
    glasfaser                number(1, 0),
    internet                 number(1, 0),
    telefon                  number(1, 0),
    tv                       number(1, 0),
    email_noetig             number(1, 0),
    folgeprodukt_template_id varchar2(100 byte),
    status                   varchar2(1 byte),
    pos                      number
);

alter table roma_main.ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_pk primary key ( template_id )
        using index enable;

