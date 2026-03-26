-- liquibase formatted sql
-- changeset AM_MAIN:1774556571930 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_krit_dienstlstg_e1_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_krit_dienstlstg_e1_dml.sql:null:11815a95082a4553068d0c291cb8c31553245495:create

create or replace package am_main.pck_hwas_krit_dienstlstg_e1_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_krit_dienstlstg_e1.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_krit_dienstlstg_e1. Return PK.
*
* @param       pior_hwas_krit_dienstlstg_e1  IN OUT hwas_krit_dienstlstg_e1%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_krit_dienstlstg_e1 in out hwas_krit_dienstlstg_e1%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_krit_dienstlstg_e1. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_krit_dienstlstg_e1   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_krit_dienstlstg_e1 in hwas_krit_dienstlstg_e1%rowtype,
        piv_art                     in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_krit_dienstlstg_e1.
*
* @param       pir_hwas_krit_dienstlstg_e1  IN hwas_krit_dienstlstg_e1%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_krit_dienstlstg_e1 in hwas_krit_dienstlstg_e1%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_krit_dienstlstg_e1.
*
* @param       pin_kd1_uid IN hwas_krit_dienstlstg_e1.kd1_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_kd1_uid in hwas_krit_dienstlstg_e1.kd1_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_krit_dienstlstg_e1%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_krit_dienstlstg_e1%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_krit_dienstlstg_e1_dml;
/

