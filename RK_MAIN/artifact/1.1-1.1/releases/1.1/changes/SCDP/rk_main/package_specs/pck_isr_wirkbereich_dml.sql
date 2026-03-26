-- liquibase formatted sql
-- changeset RK_MAIN:1774555712784 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_wirkbereich_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_wirkbereich_dml.sql:null:fea56961e1f6a4acd28ef228cb51ace92a3c0456:create

create or replace package rk_main.pck_isr_wirkbereich_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_wirkbereich.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_wirkbereich. Return PK.
*
* @param       pior_isr_wirkbereich  IN OUT isr_wirkbereich%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_wirkbereich in out isr_wirkbereich%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_wirkbereich. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_wirkbereich   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_wirkbereich in isr_wirkbereich%rowtype,
        piv_art             in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_wirkbereich.
*
* @param       pir_isr_wirkbereich  IN isr_wirkbereich%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_wirkbereich in isr_wirkbereich%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_wirkbereich.
*
* @param       pin_wbr_uid IN isr_wirkbereich.wbr_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_wbr_uid in isr_wirkbereich.wbr_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_wirkbereich%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_wirkbereich%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_wirkbereich_dml;
/

