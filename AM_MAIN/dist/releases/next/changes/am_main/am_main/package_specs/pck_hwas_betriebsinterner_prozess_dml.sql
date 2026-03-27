-- liquibase formatted sql
-- changeset AM_MAIN:1774600120267 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_betriebsinterner_prozess_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_betriebsinterner_prozess_dml.sql:null:64b796764b89458c5dae157dd0bff9e7a94badb8:create

create or replace package am_main.pck_hwas_betriebsinterner_prozess_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_betriebsinterner_prozess.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_betriebsinterner_prozess. Return PK.
*
* @param       pior_hwas_betriebsinterner_prozess  IN OUT hwas_betriebsinterner_prozess%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_betriebsinterner_prozess in out hwas_betriebsinterner_prozess%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_betriebsinterner_prozess. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_betriebsinterner_prozess   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_betriebsinterner_prozess in hwas_betriebsinterner_prozess%rowtype,
        piv_art                           in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_betriebsinterner_prozess.
*
* @param       pir_hwas_betriebsinterner_prozess  IN hwas_betriebsinterner_prozess%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_betriebsinterner_prozess in hwas_betriebsinterner_prozess%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_betriebsinterner_prozess.
*
* @param       pin_bip_uid IN hwas_betriebsinterner_prozess.bip_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_bip_uid in hwas_betriebsinterner_prozess.bip_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_betriebsinterner_prozess%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_betriebsinterner_prozess%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_betriebsinterner_prozess_dml;
/

