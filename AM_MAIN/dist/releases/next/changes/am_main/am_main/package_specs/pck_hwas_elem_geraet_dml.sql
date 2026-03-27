-- liquibase formatted sql
-- changeset AM_MAIN:1774600120467 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_elem_geraet_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_elem_geraet_dml.sql:null:9c7f918677f152de41b7b997b37a395358f762cd:create

create or replace package am_main.pck_hwas_elem_geraet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_elem_geraet.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_elem_geraet. Return PK.
*
* @param       pior_hwas_elem_geraet  IN OUT hwas_elem_geraet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_elem_geraet in out hwas_elem_geraet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_elem_geraet. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_elem_geraet   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_elem_geraet in hwas_elem_geraet%rowtype,
        piv_art              in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_elem_geraet.
*
* @param       pir_hwas_elem_geraet  IN hwas_elem_geraet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_elem_geraet in hwas_elem_geraet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_elem_geraet.
*
* @param       pin_elg_uid IN hwas_elem_geraet.elg_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_elg_uid in hwas_elem_geraet.elg_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_elem_geraet%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_elem_geraet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_elem_geraet_dml;
/

