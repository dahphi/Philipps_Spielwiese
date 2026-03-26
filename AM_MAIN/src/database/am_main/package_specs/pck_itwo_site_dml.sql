create or replace package am_main.pck_itwo_site_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_SITE. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT ITWO_SITE%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_site in out itwo_site%rowtype
    );

    procedure p_update (
        pior_itwo_site in out itwo_site%rowtype
    );

end pck_itwo_site_dml;
/


-- sqlcl_snapshot {"hash":"cc8a9d541f11cd6dab770e66af7bfd413013c7ab","type":"PACKAGE_SPEC","name":"PCK_ITWO_SITE_DML","schemaName":"AM_MAIN","sxml":""}