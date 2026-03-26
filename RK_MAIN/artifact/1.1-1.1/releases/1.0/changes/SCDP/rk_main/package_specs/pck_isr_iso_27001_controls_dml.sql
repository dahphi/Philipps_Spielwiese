-- liquibase formatted sql
-- changeset RK_MAIN:1774554920473 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_iso_27001_controls_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_iso_27001_controls_dml.sql:null:9602dd1a42245b7f48e07e425d2b76bc9646d1fd:create

create or replace package rk_main.pck_isr_iso_27001_controls_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_iso_27001_controls.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_iso_27001_controls. Return PK.
*
* @param       pior_isr_iso_27001_controls  IN OUT isr_iso_27001_controls%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_iso_27001_controls in out isr_iso_27001_controls%rowtype
    );

---KHU EDIT------
    procedure p_insert (
        pi_msn_uid in isr_massnahme_iso_27001.msn_uid%type,
        pi_i2c_uid in isr_massnahme_iso_27001.i2c_uid%type
    );

    procedure p_delete (
        pi_msn_uid in isr_massnahme_iso_27001.msn_uid%type
    );
---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_iso_27001_controls. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_iso_27001_controls   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_iso_27001_controls in isr_iso_27001_controls%rowtype,
        piv_art                    in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_iso_27001_controls.
*
* @param       pir_isr_iso_27001_controls  IN isr_iso_27001_controls%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_iso_27001_controls in isr_iso_27001_controls%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_iso_27001_controls.
*
* @param       pin_i2c_uid IN isr_iso_27001_controls.i2c_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_i2c_uid in isr_iso_27001_controls.i2c_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_iso_27001_controls%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_iso_27001_controls%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_iso_27001_controls_dml;
/

