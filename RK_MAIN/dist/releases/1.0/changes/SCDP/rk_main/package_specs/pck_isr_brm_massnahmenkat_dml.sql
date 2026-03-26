-- liquibase formatted sql
-- changeset RK_MAIN:1774554920432 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_brm_massnahmenkat_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_brm_massnahmenkat_dml.sql:null:498b629c357f3c39d3ea66449138f33b877f5e59:create

create or replace package rk_main.pck_isr_brm_massnahmenkat_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_brm_massnahmenkat.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_brm_massnahmenkat. Return PK.
*
* @param       pior_isr_brm_massnahmenkat  IN OUT isr_brm_massnahmenkat%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_brm_massnahmenkat in out isr_brm_massnahmenkat%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_brm_massnahmenkat. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_brm_massnahmenkat   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_brm_massnahmenkat in isr_brm_massnahmenkat%rowtype,
        piv_art                   in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_brm_massnahmenkat.
*
* @param       pir_isr_brm_massnahmenkat  IN isr_brm_massnahmenkat%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_brm_massnahmenkat in isr_brm_massnahmenkat%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_brm_massnahmenkat.
*
* @param       pin_mka_uid IN isr_brm_massnahmenkat.mka_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_mka_uid in isr_brm_massnahmenkat.mka_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_brm_massnahmenkat%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_brm_massnahmenkat%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_brm_massnahmenkat_dml;
/

