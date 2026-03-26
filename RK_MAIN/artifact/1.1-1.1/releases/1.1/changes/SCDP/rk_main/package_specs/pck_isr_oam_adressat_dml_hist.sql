-- liquibase formatted sql
-- changeset RK_MAIN:1774555712630 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_adressat_dml_hist.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_adressat_dml_hist.sql:null:7075fe579a1a92015feb645ee98e8dbbb69c3595:create

create or replace package rk_main.pck_isr_oam_adressat_dml_hist as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ISR_OAM_ADRESSAT_HIST.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ISR_OAM_ADRESSAT_HIST. Return PK.
*
* @param       pior_isr_oam_risikoinventar  IN OUT ISR_OAM_ADRESSAT_HIST%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_adressat_hist in out isr_oam_adressat%rowtype,
        pi_history_type            in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN ISR_OAM_ADRESSAT_HIST%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_adressat_hist%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_adressat_dml_hist;
/

