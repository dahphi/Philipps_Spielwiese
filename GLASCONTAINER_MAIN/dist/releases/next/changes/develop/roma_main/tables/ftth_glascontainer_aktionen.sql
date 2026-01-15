-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480991230 stripComments:false logicalFilePath:develop/roma_main/tables/ftth_glascontainer_aktionen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/tables/ftth_glascontainer_aktionen.sql:null:47c0362a92065a26ac57f49accc03e252a5494b6:create

create table roma_main.ftth_glascontainer_aktionen (
    code        varchar2(30 byte) not null enable,
    name        varchar2(100 byte) not null enable,
    gueltig_ab  date,
    gueltig_bis date,
    aktuell     number(1, 0),
    status      varchar2(1 byte)
);

alter table roma_main.ftth_glascontainer_aktionen
    add constraint ftth_glascontainer_aktionen_pk primary key ( code )
        using index enable;

