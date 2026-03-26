-- liquibase formatted sql
-- changeset AM_MAIN:1774557120227 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_tk_technologie_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_tk_technologie_dml.sql:null:0f22d85230035242371fa630c694727d20e25c01:create

create or replace package am_main.pck_hwas_tk_technologie_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_tk_technologie.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_tk_technologie. Return PK.
*
* @param       pior_hwas_tk_technologie  IN OUT hwas_tk_technologie%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_tk_technologie in out hwas_tk_technologie%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_tk_technologie. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_tk_technologie   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_tk_technologie in hwas_tk_technologie%rowtype,
        piv_art                 in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_tk_technologie.
*
* @param       pir_hwas_tk_technologie  IN hwas_tk_technologie%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_tk_technologie in hwas_tk_technologie%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_tk_technologie.
*
* @param       pin_tkt_uid IN hwas_tk_technologie.tkt_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_tkt_uid in hwas_tk_technologie.tkt_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_tk_technologie%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_tk_technologie%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_tk_technologie_dml;
/

