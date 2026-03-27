-- liquibase formatted sql
-- changeset AM_MAIN:1774605607184 stripComments:false logicalFilePath:am_main/am_main/tables/bsi_baustein_schicht.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/bsi_baustein_schicht.sql:null:cdeeff52dd323a2a3caf4ad9e8d3829acc7cc9c4:create

create table am_main.bsi_baustein_schicht (
    bss_id       number,
    schicht_name varchar2(50 byte)
)
no inmemory;

alter table am_main.bsi_baustein_schicht add primary key ( bss_id )
    using index enable;

