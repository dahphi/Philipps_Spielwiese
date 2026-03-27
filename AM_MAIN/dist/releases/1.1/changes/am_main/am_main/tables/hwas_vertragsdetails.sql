-- liquibase formatted sql
-- changeset AM_MAIN:1774605609613 stripComments:false logicalFilePath:am_main/am_main/tables/hwas_vertragsdetails.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/hwas_vertragsdetails.sql:fccdc9aeecf5dfd21c61139c8484ea1d8d81fc8a:535e3201b742cf35f49dea64ce43bfa4301818a6:alter

alter table am_main.hwas_vertragsdetails add (
    betriebsrelevanz number
)
/

