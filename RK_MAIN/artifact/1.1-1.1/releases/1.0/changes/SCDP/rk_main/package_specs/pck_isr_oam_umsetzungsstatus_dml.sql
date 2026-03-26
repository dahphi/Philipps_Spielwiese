-- liquibase formatted sql
-- changeset RK_MAIN:1774554920676 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_umsetzungsstatus_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_umsetzungsstatus_dml.sql:null:f01ccb4241c7c14901de85600c16ba9a8d0504ae:create

create or replace package rk_main.pck_isr_oam_umsetzungsstatus_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_umsetzungsstatus.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_umsetzungsstatus. Return PK.
*
* @param       pior_isr_oam_umsetzungsstatus  IN OUT isr_oam_umsetzungsstatus%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_umsetzungsstatus in out isr_oam_umsetzungsstatus%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_umsetzungsstatus. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_umsetzungsstatus   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_umsetzungsstatus in isr_oam_umsetzungsstatus%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_umsetzungsstatus.
*
* @param       pir_isr_oam_umsetzungsstatus  IN isr_oam_umsetzungsstatus%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_umsetzungsstatus in isr_oam_umsetzungsstatus%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_umsetzungsstatus.
*
* @param       pin_uss_uid IN isr_oam_umsetzungsstatus.uss_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_uss_uid in isr_oam_umsetzungsstatus.uss_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_umsetzungsstatus%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_umsetzungsstatus%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_umsetzungsstatus_dml;
/

