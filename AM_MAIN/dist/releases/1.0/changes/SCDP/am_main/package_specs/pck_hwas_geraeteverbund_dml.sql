-- liquibase formatted sql
-- changeset AM_MAIN:1774556571870 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_geraeteverbund_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_geraeteverbund_dml.sql:null:76bd7f35e1b0bd18a0deae5ce4c2b1e0d92e184f:create

create or replace package am_main.pck_hwas_geraeteverbund_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_geraeteverbund.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_geraeteverbund. Return PK.
*
* @param       pior_hwas_geraeteverbund  IN OUT hwas_geraeteverbund%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_geraeteverbund in out hwas_geraeteverbund%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_geraeteverbund. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_geraeteverbund   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_geraeteverbund in hwas_geraeteverbund%rowtype,
        piv_art                 in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_geraeteverbund.
*
* @param       pir_hwas_geraeteverbund  IN hwas_geraeteverbund%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_geraeteverbund in hwas_geraeteverbund%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_geraeteverbund.
*
* @param       pin_gvb_uid IN hwas_geraeteverbund.gvb_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_gvb_uid in hwas_geraeteverbund.gvb_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_geraeteverbund%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_geraeteverbund%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_geraeteverbund_dml;
/

