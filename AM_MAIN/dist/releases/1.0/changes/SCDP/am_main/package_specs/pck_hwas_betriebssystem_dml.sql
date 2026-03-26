-- liquibase formatted sql
-- changeset AM_MAIN:1774556571772 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_betriebssystem_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_betriebssystem_dml.sql:null:bf7f115c20484d90ce4042ad03fca6bf9a0d7693:create

create or replace package am_main.pck_hwas_betriebssystem_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_betriebssystem.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_betriebssystem. Return PK.
*
* @param       pior_hwas_betriebssystem  IN OUT hwas_betriebssystem%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_betriebssystem in out hwas_betriebssystem%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_betriebssystem. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_betriebssystem   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_betriebssystem in hwas_betriebssystem%rowtype,
        piv_art                 in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_betriebssystem.
*
* @param       pir_hwas_betriebssystem  IN hwas_betriebssystem%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_betriebssystem in hwas_betriebssystem%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_betriebssystem.
*
* @param       pin_hst_uid IN hwas_betriebssystem.system_id
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_system_id in hwas_betriebssystem.system_id%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_betriebssystem%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_betriebssystem%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_betriebssystem_dml;
/

