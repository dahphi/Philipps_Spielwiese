-- liquibase formatted sql
-- changeset AM_MAIN:1774600120847 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_hersteller_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_hersteller_dml.sql:null:f1056ec4c4d32f4f0b7877582ffe41cf15161e4c:create

create or replace package am_main.pck_hwas_hersteller_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_hersteller.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_hersteller. Return PK.
*
* @param       pior_hwas_hersteller  IN OUT hwas_hersteller%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_hersteller in out hwas_hersteller%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_hersteller. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_hersteller   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_hersteller in hwas_hersteller%rowtype,
        piv_art             in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_hersteller.
*
* @param       pir_hwas_hersteller  IN hwas_hersteller%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_hersteller in hwas_hersteller%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_hersteller.
*
* @param       pin_hst_uid IN hwas_hersteller.hst_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_hst_uid in hwas_hersteller.hst_uid%type
    );

---------------------------------------------------------------------------------------------------
/**
* Insert des uebergebenen Records in Tabelle HWAS_HERSTELLER. Return PK.
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert_hwdb_hersteller;

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_hersteller%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_hersteller%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_hersteller_dml;
/

