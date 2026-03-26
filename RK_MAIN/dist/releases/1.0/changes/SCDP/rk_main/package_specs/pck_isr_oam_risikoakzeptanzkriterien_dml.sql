-- liquibase formatted sql
-- changeset RK_MAIN:1774561694235 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_risikoakzeptanzkriterien_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_risikoakzeptanzkriterien_dml.sql:null:4d0663e735f12569eb76befa8ea905bdcddee8e9:create

create or replace package rk_main.pck_isr_oam_risikoakzeptanzkriterien_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_risikoakzeptanzkriterien.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_risikoakzeptanzkriterien. Return PK.
*
* @param       pior_isr_oam_risikoakzeptanzkriterien  IN OUT isr_oam_risikoakzeptanzkriterien%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_risikoakzeptanzkriterien in out isr_oam_risikoakzeptanzkriterien%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_risikoakzeptanzkriterien. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_risikoakzeptanzkriterien   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_risikoakzeptanzkriterien in isr_oam_risikoakzeptanzkriterien%rowtype,
        piv_art                              in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_risikoakzeptanzkriterien.
*
* @param       pir_isr_oam_risikoakzeptanzkriterien  IN isr_oam_risikoakzeptanzkriterien%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_risikoakzeptanzkriterien in isr_oam_risikoakzeptanzkriterien%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_risikoakzeptanzkriterien.
*
* @param       pin_rak_uid IN isr_oam_risikoakzeptanzkriterien.rak_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_rak_uid in isr_oam_risikoakzeptanzkriterien.rak_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_risikoakzeptanzkriterien%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_risikoakzeptanzkriterien%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_risikoakzeptanzkriterien_dml;
/

