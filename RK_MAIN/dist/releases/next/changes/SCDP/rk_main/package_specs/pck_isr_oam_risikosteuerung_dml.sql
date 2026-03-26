-- liquibase formatted sql
-- changeset RK_MAIN:1774561694279 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_risikosteuerung_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_risikosteuerung_dml.sql:null:cd73aed8d72a5b03475db578a36af6102e9e3e78:create

create or replace package rk_main.pck_isr_oam_risikosteuerung_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_risikosteuerung.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_risikosteuerung. Return PK.
*
* @param       pior_isr_oam_risikosteuerung  IN OUT isr_oam_risikosteuerung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_risikosteuerung in out isr_oam_risikosteuerung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_risikosteuerung. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_risikosteuerung   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_risikosteuerung in isr_oam_risikosteuerung%rowtype,
        piv_art                     in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_risikosteuerung.
*
* @param       pir_isr_oam_risikosteuerung  IN isr_oam_risikosteuerung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_risikosteuerung in isr_oam_risikosteuerung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_risikosteuerung.
*
* @param       pin_ris_uid IN isr_oam_risikosteuerung.ris_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ris_uid in isr_oam_risikosteuerung.ris_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_risikosteuerung%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_risikosteuerung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_risikosteuerung_dml;
/

