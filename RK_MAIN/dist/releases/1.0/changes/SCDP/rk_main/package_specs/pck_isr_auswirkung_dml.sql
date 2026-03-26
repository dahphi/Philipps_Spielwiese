-- liquibase formatted sql
-- changeset RK_MAIN:1774561694038 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_auswirkung_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_auswirkung_dml.sql:null:15b0537f477381db9250a0f3f9535a9d9089d5b1:create

create or replace package rk_main.pck_isr_auswirkung_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_auswirkung.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_auswirkung. Return PK.
*
* @param       pior_isr_auswirkung  IN OUT isr_auswirkung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_auswirkung in out isr_auswirkung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_auswirkung. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_auswirkung   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_auswirkung in isr_auswirkung%rowtype,
        piv_art            in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_auswirkung.
*
* @param       pir_isr_auswirkung  IN isr_auswirkung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_auswirkung in isr_auswirkung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_auswirkung.
*
* @param       pin_auw_uid IN isr_auswirkung.auw_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_auw_uid in isr_auswirkung.auw_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_auswirkung%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_auswirkung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_auswirkung_dml;
/

