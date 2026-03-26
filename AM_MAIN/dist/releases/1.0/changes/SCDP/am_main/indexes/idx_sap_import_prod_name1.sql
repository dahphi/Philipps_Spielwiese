-- liquibase formatted sql
-- changeset AM_MAIN:1774556567761 stripComments:false logicalFilePath:SCDP/am_main/indexes/idx_sap_import_prod_name1.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/indexes/idx_sap_import_prod_name1.sql:null:d440fbc42cd22755d6887c3d6f362aaf0a4fd344:create

create index am_main.idx_sap_import_prod_name1 on
    am_main.sap_import_prod (
        name1
    );

