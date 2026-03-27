-- liquibase formatted sql
-- changeset AM_MAIN:1774605607197 stripComments:false logicalFilePath:am_main/am_main/tables/bsi_bausteinart.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_bausteinart.sql:null:877cc8f8fd6ab6a5d66eb4e499ab5c206c37d832:create

create table am_main.bsi_bausteinart (
    art_id number,
    name   varchar2(50 byte)
)
no inmemory;

alter table am_main.bsi_bausteinart add primary key ( art_id )
    using index enable;

