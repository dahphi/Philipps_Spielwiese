-- liquibase formatted sql
-- changeset AM_MAIN:1774556571987 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_netz_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_netz_dml.sql:null:ec6a42531dbcccce5d7782386d99b8bd3d8aec47:create

create or replace package am_main.pck_hwas_netz_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_netz.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_netz. Return PK.
*
* @param       pior_hwas_netz  IN OUT hwas_netz%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_netz in out hwas_netz%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_netz. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_netz   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_netz in hwas_netz%rowtype,
        piv_art       in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_netz.
*
* @param       pir_hwas_netz  IN hwas_netz%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_netz in hwas_netz%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_netz.
*
* @param       pin_net_uid IN hwas_netz.net_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_net_uid in hwas_netz.net_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_netz%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_netz%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_netz_dml;
/

