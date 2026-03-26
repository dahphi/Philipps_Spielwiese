create or replace package am_main.pkg_sap_bestellungen_import as
    procedure pr_update_bestellungen_import;

    procedure pr_neuer_lieferanten_import;

    procedure pr_neue_warengruppen_import;

    procedure pr_neue_bestellungen_import;

end pkg_sap_bestellungen_import;
/


-- sqlcl_snapshot {"hash":"8caedf387e558bc179c926a8d4d2a588688bace0","type":"PACKAGE_SPEC","name":"PKG_SAP_BESTELLUNGEN_IMPORT","schemaName":"AM_MAIN","sxml":""}