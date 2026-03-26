-- liquibase formatted sql
-- changeset AM_MAIN:1774556571859 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_geraeteklasse_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_geraeteklasse_dml.sql:null:d978dbab631735f6da7791ac7f0f70e2323d91b8:create

create or replace package am_main.pck_hwas_geraeteklasse_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_geraeteklasse.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_geraeteklasse. Return PK.
*
* @param       pior_hwas_geraeteklasse  IN OUT hwas_geraeteklasse%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_geraeteklasse in out hwas_geraeteklasse%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_geraeteklasse. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_geraeteklasse   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_geraeteklasse in hwas_geraeteklasse%rowtype,
        piv_art                in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_geraeteklasse.
*
* @param       pir_hwas_geraeteklasse  IN hwas_geraeteklasse%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_geraeteklasse in hwas_geraeteklasse%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_geraeteklasse.
*
* @param       pin_gkl_uid IN hwas_geraeteklasse.gkl_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_gkl_uid in hwas_geraeteklasse.gkl_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_geraeteklasse%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_geraeteklasse%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_geraeteklasse_dml;
/

