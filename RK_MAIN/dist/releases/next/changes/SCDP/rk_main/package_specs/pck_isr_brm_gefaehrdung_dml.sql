-- liquibase formatted sql
-- changeset RK_MAIN:1774561694061 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_brm_gefaehrdung_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_brm_gefaehrdung_dml.sql:null:e7d1b2f9dfbe698053019b64b75604e75b6051e0:create

create or replace package rk_main.pck_isr_brm_gefaehrdung_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_brm_gefaehrdung.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_brm_gefaehrdung. Return PK.
*
* @param       pior_isr_brm_gefaehrdung  IN OUT isr_brm_gefaehrdung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_brm_gefaehrdung in out isr_brm_gefaehrdung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_brm_gefaehrdung. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_brm_gefaehrdung   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_brm_gefaehrdung in isr_brm_gefaehrdung%rowtype,
        piv_art                 in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_brm_gefaehrdung.
*
* @param       pir_isr_brm_gefaehrdung  IN isr_brm_gefaehrdung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_brm_gefaehrdung in isr_brm_gefaehrdung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_brm_gefaehrdung.
*
* @param       pin_gef_uid IN isr_brm_gefaehrdung.gef_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_gef_uid in isr_brm_gefaehrdung.gef_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_brm_gefaehrdung%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_brm_gefaehrdung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_brm_gefaehrdung_dml;
/

