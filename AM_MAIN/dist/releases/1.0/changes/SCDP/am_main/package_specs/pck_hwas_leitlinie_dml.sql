-- liquibase formatted sql
-- changeset AM_MAIN:1774556571952 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_leitlinie_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_leitlinie_dml.sql:null:372d8e874732a4cc65572efefbf9f73867da907a:create

create or replace package am_main.pck_hwas_leitlinie_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_leitlinie.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_leitlinie. Return PK.
*
* @param       pior_hwas_leitlinie  IN OUT hwas_leitlinie%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_leitlinie in out hwas_leitlinie%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_leitlinie. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_leitlinie   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_leitlinie in hwas_leitlinie%rowtype,
        piv_art            in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_leitlinie.
*
* @param       pir_hwas_leitlinie  IN hwas_leitlinie%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_leitlinie in hwas_leitlinie%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_leitlinie.
*
* @param       pin_ll_uid IN hwas_leitlinie.ll_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ll_uid in hwas_leitlinie.ll_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_leitlinie%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_leitlinie%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_leitlinie_dml;
/

