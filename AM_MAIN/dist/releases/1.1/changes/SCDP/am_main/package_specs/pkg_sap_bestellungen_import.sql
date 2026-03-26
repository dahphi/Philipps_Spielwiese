-- liquibase formatted sql
-- changeset AM_MAIN:1774557120337 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pkg_sap_bestellungen_import.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pkg_sap_bestellungen_import.sql:null:8caedf387e558bc179c926a8d4d2a588688bace0:create

create or replace package am_main.pkg_sap_bestellungen_import as
    procedure pr_update_bestellungen_import;

    procedure pr_neuer_lieferanten_import;

    procedure pr_neue_warengruppen_import;

    procedure pr_neue_bestellungen_import;

end pkg_sap_bestellungen_import;
/

