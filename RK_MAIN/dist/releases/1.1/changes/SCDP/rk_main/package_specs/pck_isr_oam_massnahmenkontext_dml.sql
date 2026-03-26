-- liquibase formatted sql
-- changeset RK_MAIN:1774555712696 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_massnahmenkontext_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_massnahmenkontext_dml.sql:null:4daa3eb4a43330106f14e585fedc5cce12f95091:create

create or replace package rk_main.pck_isr_oam_massnahmenkontext_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_massnahmenkontext.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_massnahmenkontext. Return PK.
*
* @param       pior_isr_oam_massnahmenkontext  IN OUT isr_oam_massnahmenkontext%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_massnahmenkontext in out isr_oam_massnahmenkontext%rowtype
    );

--KHU EDIT--
    procedure p_insert (
        pi_msn_uid in isr_massnahme_kontext.msn_uid%type,
        pi_mkt_uid in isr_massnahme_kontext.mkt_uid%type
    );

    procedure p_delete (
        pi_msn_uid in isr_massnahme_kontext.msn_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_massnahmenkontext. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_massnahmenkontext   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_oam_massnahmenkontext in isr_oam_massnahmenkontext%rowtype,
        piv_art                       in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_oam_massnahmenkontext.
*
* @param       pir_isr_oam_massnahmenkontext  IN isr_oam_massnahmenkontext%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_oam_massnahmenkontext in isr_oam_massnahmenkontext%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_massnahmenkontext.
*
* @param       pin_mkt_uid IN isr_oam_massnahmenkontext.mkt_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_mkt_uid in isr_oam_massnahmenkontext.mkt_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_massnahmenkontext%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_massnahmenkontext%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_massnahmenkontext_dml;
/

