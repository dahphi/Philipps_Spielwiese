-- liquibase formatted sql
-- changeset AM_MAIN:1774557115621 stripComments:false logicalFilePath:SCDP/am_main/indexes/idx_sap_bestellungen_pk_sap.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/idx_sap_bestellungen_pk_sap.sql:null:757bf26e371cb3614f77914c745d91284bb4f952:create

create index am_main.idx_sap_bestellungen_pk_sap on
    am_main.hwas_sap_beauftragungen (
        primarykey_sap
    );

