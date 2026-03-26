-- liquibase formatted sql
-- changeset AM_MAIN:1774557119967 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_funk_infcluster_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_funk_infcluster_dml.sql:null:cd575920ae393588d104f2168155ec242aab71a2:create

create or replace package am_main.pck_hwas_funk_infcluster_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle HWAS_FUNK_INFCLUSTER.
*
*/
---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle HWAS_FUNK_INFCLUSTER. Return PK.
*
* @param       pior_HWAS_FUNK_INFCLUSTER  IN OUT HWAS_FUNK_INFCLUSTER%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_funk_infcluster in out hwas_funk_infcluster%rowtype
    );

    procedure p_insert (
        pi_fkl_uid  in hwas_funk_infcluster.fkl_uid%type,
        pi_incl_uid in hwas_funk_infcluster.incl_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle HWAS_FUNK_INFCLUSTER. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_FUNK_INFCLUSTER   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_funk_infcluster in hwas_funk_infcluster%rowtype,
        piv_art                  in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle HWAS_FUNK_INFCLUSTER.
*
* @param       pir_HWAS_FUNK_INFCLUSTER  IN HWAS_FUNK_INFCLUSTER%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_funk_infcluster in hwas_funk_infcluster%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle HWAS_FUNK_INFCLUSTER.
*
* @param       pin_mka_uid IN HWAS_FUNK_INFCLUSTER.FKIN_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_fkl_uid in hwas_funk_infcluster.fkl_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN HWAS_FUNK_INFCLUSTER%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_funk_infcluster%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_funk_infcluster_dml;
/

