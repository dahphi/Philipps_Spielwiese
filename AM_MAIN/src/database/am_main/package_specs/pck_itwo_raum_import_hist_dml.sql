create or replace package am_main.pck_itwo_raum_import_hist_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_RAUM_import_hist. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT ITWO_RAUM_import_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_raum_import_hist in out itwo_raum_import_hist%rowtype
    );

    procedure p_import_itwo_raum;

end pck_itwo_raum_import_hist_dml;
/


-- sqlcl_snapshot {"hash":"cb4cdf106a905b286c8ec67d5d1ec6361970cf5d","type":"PACKAGE_SPEC","name":"PCK_ITWO_RAUM_IMPORT_HIST_DML","schemaName":"AM_MAIN","sxml":""}