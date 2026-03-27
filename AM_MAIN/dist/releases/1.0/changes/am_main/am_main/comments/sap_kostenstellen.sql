-- liquibase formatted sql
-- changeset am_main:1774600099459 stripComments:false logicalFilePath:am_main/am_main/comments/sap_kostenstellen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/sap_kostenstellen.sql:null:94e5cc1aab79c7af682c6a12089f118095d7fc1b:create

comment on column am_main.sap_kostenstellen.lebenszyklus is
    'Lebenszyklus für Kostenstellen, unabhängig von dem Lebenszyklus für die Assets';

