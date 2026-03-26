-- liquibase formatted sql
-- changeset RK_MAIN:1774554920523 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_adressat_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_adressat_dml.sql:null:7a4a7e1084e623cbbb1fe5e156d060afcf1fd987:create

create or replace package rk_main.pck_isr_oam_adressat_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_adressat.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_adressat. Return PK.
*
* @param       pior_isr_oam_adressat  IN OUT isr_oam_adressat%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_adressat in out isr_oam_adressat%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_adressat. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_adressat   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_adressat in isr_oam_adressat%rowtype,
        piv_art              in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_adressat.
*
* @param       pir_isr_oam_adressat  IN isr_oam_adressat%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_adressat in isr_oam_adressat%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_adressat.
*
* @param       pin_adr_uid IN isr_oam_adressat.adr_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_adr_uid in isr_oam_adressat.adr_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_adressat%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_adressat%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

/**
* Mittels uebergebenen msn_uid delete RecordS aus Tabelle isr_oam_adressat.
*
* @param       pin_MSN_uid IN isr_oam_adressat.MSN_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete_for_msn (
        pin_msn_uid in isr_oam_adressat.msn_uid%type
    );

---------------------------------------------------------------------------------------------------


end pck_isr_oam_adressat_dml;
/

