-- liquibase formatted sql
-- changeset AM_MAIN:1774605609419 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_produktbestandteil.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_produktbestandteil.sql:2359ef197def5ec7a3e0b1f7f75f90e0ecde9241:14c68364e25661d3612d4c2d19b26557f9548ce0:alter

alter table am_main.hwas_produktbestandteil add (
    tech_ansprechpartner varchar2(200)
)
/

