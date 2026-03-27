-- liquibase formatted sql
-- changeset AM_MAIN:1774605607208 stripComments:false logicalFilePath:am_main/am_main/tables/bsi_iv_relevanz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_iv_relevanz.sql:null:0aa942ce5001928106e3538b28bc5632213735e1:create

create table am_main.bsi_iv_relevanz (
    ivr_id number,
    name   varchar2(200 byte)
)
no inmemory;

alter table am_main.bsi_iv_relevanz add primary key ( ivr_id )
    using index enable;

