create or replace package am_main.pck_itwo_site_import_hist_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_SITE_import_hist. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT ITWO_SITE_import_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_site_import_hist in out itwo_site_import_hist%rowtype
    );

    procedure p_import_itwo_site;

end pck_itwo_site_import_hist_dml;
/


-- sqlcl_snapshot {"hash":"807bef9280c478dbb1b3b1eb96f6b8cd08248cb1","type":"PACKAGE_SPEC","name":"PCK_ITWO_SITE_IMPORT_HIST_DML","schemaName":"AM_MAIN","sxml":""}