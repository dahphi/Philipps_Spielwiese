-- liquibase formatted sql
-- changeset RK_MAIN:1774555712584 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_iso_27001_kapitel_a_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_iso_27001_kapitel_a_dml.sql:null:75cfd2bde8501f6c65343907b2acd24977952bd0:create

create or replace package rk_main.pck_isr_iso_27001_kapitel_a_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ISR_ISO_27001_KAPITEL_A.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ISR_ISO_27001_KAPITEL_A. Return PK.
*
* @param       pior_ISR_ISO_27001_KAPITEL_A  IN OUT ISR_ISO_27001_KAPITEL_A%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_iso_27001_kapitel_a in out isr_iso_27001_kapitel_a%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle ISR_ISO_27001_KAPITEL_A. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_ISR_ISO_27001_KAPITEL_A   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_iso_27001_kapitel_a in isr_iso_27001_kapitel_a%rowtype,
        piv_art                     in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle ISR_ISO_27001_KAPITEL_A.
*
* @param       pir_ISR_ISO_27001_KAPITEL_A  IN ISR_ISO_27001_KAPITEL_A%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_iso_27001_kapitel_a in isr_iso_27001_kapitel_a%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle ISR_ISO_27001_KAPITEL_A.
*
* @param       pin_KAP_UID IN ISR_ISO_27001_KAPITEL_A.KAP_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_kap_uid in isr_iso_27001_kapitel_a.kap_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN ISR_ISO_27001_KAPITEL_A%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_iso_27001_kapitel_a%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_iso_27001_kapitel_a_dml;
/

