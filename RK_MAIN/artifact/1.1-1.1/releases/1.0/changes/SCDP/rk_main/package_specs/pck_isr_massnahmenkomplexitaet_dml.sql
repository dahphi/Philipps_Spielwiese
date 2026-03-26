-- liquibase formatted sql
-- changeset RK_MAIN:1774554920509 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_massnahmenkomplexitaet_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_massnahmenkomplexitaet_dml.sql:null:70c3b7e842445efbc12fa1eed9a8834d8dacf5a3:create

create or replace package rk_main.pck_isr_massnahmenkomplexitaet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_massnahmenkomplexitaet.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_massnahmenkomplexitaet. Return PK.
*
* @param       pior_isr_massnahmenkomplexitaet  IN OUT isr_massnahmenkomplexitaet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_massnahmenkomplexitaet in out isr_massnahmenkomplexitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_massnahmenkomplexitaet. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_massnahmenkomplexitaet   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_massnahmenkomplexitaet in isr_massnahmenkomplexitaet%rowtype,
        piv_art                        in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_massnahmenkomplexitaet.
*
* @param       pir_isr_massnahmenkomplexitaet  IN isr_massnahmenkomplexitaet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_massnahmenkomplexitaet in isr_massnahmenkomplexitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_massnahmenkomplexitaet.
*
* @param       pin_mkp_uid IN isr_massnahmenkomplexitaet.mkp_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_mkp_uid in isr_massnahmenkomplexitaet.mkp_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_massnahmenkomplexitaet%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_massnahmenkomplexitaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_massnahmenkomplexitaet_dml;
/

