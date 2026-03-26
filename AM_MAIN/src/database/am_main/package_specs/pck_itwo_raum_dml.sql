create or replace package am_main.pck_itwo_raum_dml as

/**
* Insert des uebergebenen Records in Tabelle ITWO_RAUM. Return PK.
*
* @param       pior_isr_oam_raum  IN OUT ITWO_RAUM%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_itwo_raum in out itwo_raum%rowtype
    );

    procedure p_update (
        pior_itwo_raum in out itwo_raum%rowtype
    );

end pck_itwo_raum_dml;
/


-- sqlcl_snapshot {"hash":"2f7ae301889415355818b82135768b184e8e58a3","type":"PACKAGE_SPEC","name":"PCK_ITWO_RAUM_DML","schemaName":"AM_MAIN","sxml":""}