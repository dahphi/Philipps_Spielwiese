-- liquibase formatted sql
-- changeset AM_MAIN:1774556572041 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_raum_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_raum_dml.sql:null:75ca9b1ee3fe5ea5af35cd24bd4e84ba27d61c2d:create

create or replace package am_main.pck_hwas_raum_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_raum.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_raum. Return PK.
*
* @param       pior_hwas_raum  IN OUT hwas_raum%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_raum in out hwas_raum%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_raum. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_raum   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_raum in hwas_raum%rowtype,
        piv_art       in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_raum.
*
* @param       pir_hwas_raum  IN hwas_raum%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_raum in hwas_raum%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_raum.
*
* @param       pin_rm_uid IN hwas_raum.rm_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_rm_uid in hwas_raum.rm_uid%type
    );
---------------------------------------------------------------------------------------------------
  /**
* Insert des uebergebenen Records in Tabelle HWAS_RAUM. Return PK.
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert_hwas_raum;

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_raum%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_raum%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_raum_dml;
/

