create or replace package am_main.pck_hwdb_hosts_import_hist_dml as

/**
* Insert des uebergebenen Records in Tabelle HWDB_HOSTS_import_hist. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT HWDB_HOSTS_import_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwdb_hosts_import_hist in out hwdb_hosts_import_hist%rowtype
    );

    procedure p_import_hwdb;

end pck_hwdb_hosts_import_hist_dml;
/


-- sqlcl_snapshot {"hash":"a1bd293175fc2c6d91810f76e4db4472bf261d83","type":"PACKAGE_SPEC","name":"PCK_HWDB_HOSTS_IMPORT_HIST_DML","schemaName":"AM_MAIN","sxml":""}