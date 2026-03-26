-- liquibase formatted sql
-- changeset AM_MAIN:1774556571998 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_netzebene_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_netzebene_dml.sql:null:31c6bbf3613dd9d323c3748d5bf2899323f3f260:create

create or replace package am_main.pck_hwas_netzebene_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_netzebene.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_netzebene. Return PK.
*
* @param       pior_hwas_netzebene  IN OUT hwas_netzebene%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_netzebene in out hwas_netzebene%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_netzebene. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_netzebene   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_netzebene in hwas_netzebene%rowtype,
        piv_art            in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_netzebene.
*
* @param       pir_hwas_netzebene  IN hwas_netzebene%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_netzebene in hwas_netzebene%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_netzebene.
*
* @param       pin_ne_uid IN hwas_netzebene.ne_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ne_uid in hwas_netzebene.ne_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_netzebene%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_netzebene%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_netzebene_dml;
/

