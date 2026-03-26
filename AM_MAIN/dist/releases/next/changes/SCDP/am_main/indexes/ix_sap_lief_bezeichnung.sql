-- liquibase formatted sql
-- changeset AM_MAIN:1774556567769 stripComments:false logicalFilePath:SCDP/am_main/indexes/ix_sap_lief_bezeichnung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/ix_sap_lief_bezeichnung.sql:null:85741db49c33b7a1f35c66b291b481706bf385de:create

create index am_main.ix_sap_lief_bezeichnung on
    am_main.sap_lieferanten (
        bezeichnung
    );

