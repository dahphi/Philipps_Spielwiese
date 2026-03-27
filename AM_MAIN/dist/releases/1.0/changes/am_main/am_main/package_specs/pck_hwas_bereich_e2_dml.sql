-- liquibase formatted sql
-- changeset AM_MAIN:1774600120216 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_bereich_e2_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_bereich_e2_dml.sql:null:4b21a99a9b82a9313017dd8a359936fe11de425a:create

create or replace package am_main.pck_hwas_bereich_e2_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_bereich_e2.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_bereich_e2. Return PK.
*
* @param       pior_hwas_bereich_e2  IN OUT hwas_bereich_e2%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_bereich_e2 in out hwas_bereich_e2%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_bereich_e2. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_bereich_e2   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_bereich_e2 in hwas_bereich_e2%rowtype,
        piv_art             in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_bereich_e2.
*
* @param       pir_hwas_bereich_e2  IN hwas_bereich_e2%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_bereich_e2 in hwas_bereich_e2%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_bereich_e2.
*
* @param       pin_be2_uid IN hwas_bereich_e2.be2_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_be2_uid in hwas_bereich_e2.be2_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_bereich_e2%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_bereich_e2%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_bereich_e2_dml;
/

