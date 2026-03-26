-- liquibase formatted sql
-- changeset RK_MAIN:1774555712719 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_risikoinventar_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_risikoinventar_dml.sql:null:d99e6cb44ae9862485ab3297aafb5f5b176064bb:create

create or replace package rk_main.pck_isr_oam_risikoinventar_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_risikoinventar.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_risikoinventar. Return PK.
*
* @param       pior_isr_oam_risikoinventar  IN OUT isr_oam_risikoinventar%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_risikoinventar in out isr_oam_risikoinventar%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_risikoinventar. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_risikoinventar   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_risikoinventar in isr_oam_risikoinventar%rowtype,
        piv_art                    in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_risikoinventar.
*
* @param       pir_isr_oam_risikoinventar  IN isr_oam_risikoinventar%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_risikoinventar in isr_oam_risikoinventar%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_risikoinventar.
*
* @param       pin_rsk_uid IN isr_oam_risikoinventar.rsk_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_rsk_uid in isr_oam_risikoinventar.rsk_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_risikoinventar%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_risikoinventar%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_risikoinventar_dml;
/

