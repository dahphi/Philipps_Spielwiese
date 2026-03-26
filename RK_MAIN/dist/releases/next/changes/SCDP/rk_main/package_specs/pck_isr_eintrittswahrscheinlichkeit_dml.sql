-- liquibase formatted sql
-- changeset RK_MAIN:1774562212141 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_eintrittswahrscheinlichkeit_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_eintrittswahrscheinlichkeit_dml.sql:null:c6e78759199bef6dfb5a677a4cd9809f11d69429:create

create or replace package rk_main.pck_isr_eintrittswahrscheinlichkeit_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_eintrittswahrscheinlichkeit.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_eintrittswahrscheinlichkeit. Return PK.
*
* @param       pior_isr_eintrittswahrscheinlichkeit  IN OUT isr_eintrittswahrscheinlichkeit%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_eintrittswahrscheinlichkeit in out isr_eintrittswahrscheinlichkeit%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_eintrittswahrscheinlichkeit. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_eintrittswahrscheinlichkeit   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_eintrittswahrscheinlichkeit in isr_eintrittswahrscheinlichkeit%rowtype,
        piv_art                             in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_eintrittswahrscheinlichkeit.
*
* @param       pir_isr_eintrittswahrscheinlichkeit  IN isr_eintrittswahrscheinlichkeit%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_eintrittswahrscheinlichkeit in isr_eintrittswahrscheinlichkeit%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_eintrittswahrscheinlichkeit.
*
* @param       pin_ews_uid IN isr_eintrittswahrscheinlichkeit.ews_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ews_uid in isr_eintrittswahrscheinlichkeit.ews_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_eintrittswahrscheinlichkeit%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_eintrittswahrscheinlichkeit%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_eintrittswahrscheinlichkeit_dml;
/

