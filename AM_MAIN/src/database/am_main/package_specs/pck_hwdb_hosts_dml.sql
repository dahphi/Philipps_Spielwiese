create or replace package am_main.pck_hwdb_hosts_dml as

/**
* Insert des uebergebenen Records in Tabelle HWDB_HOSTS. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT HWDB_HOSTS%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwdb_hosts in out hwdb_hosts%rowtype
    );

    procedure p_update (
        pior_hwdb_hosts in out hwdb_hosts%rowtype
    );

end pck_hwdb_hosts_dml;
/


-- sqlcl_snapshot {"hash":"6bca1ba16026d4386e3b0cfedb617e96f9b3e2db","type":"PACKAGE_SPEC","name":"PCK_HWDB_HOSTS_DML","schemaName":"AM_MAIN","sxml":""}