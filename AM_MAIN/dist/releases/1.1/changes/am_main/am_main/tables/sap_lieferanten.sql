-- liquibase formatted sql
-- changeset AM_MAIN:1774605609724 stripComments:false logicalFilePath:am_main/am_main/tables/sap_lieferanten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/tables/sap_lieferanten.sql:f4b6aec8002f5d5e57face6801a13a19d45fcebe:eff96044cdb24d78537b511b57245b2439e8fd08:alter

alter table am_main.sap_lieferanten add (
    bemerkung varchar2(400)
)
/

alter table am_main.sap_lieferanten add (
    gek_lfd_nr number
)
/

