-- liquibase formatted sql
-- changeset AM_MAIN:1774557120290 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwdb_hosts_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwdb_hosts_dml.sql:null:6bca1ba16026d4386e3b0cfedb617e96f9b3e2db:create

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

