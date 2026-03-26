-- liquibase formatted sql
-- changeset RK_MAIN:1774561694255 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_risikoinventar_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_risikoinventar_hist_dml.sql:null:1f4c2a3994d692f82a9fa81d37ad833c1c114f8d:create

create or replace package rk_main.pck_isr_oam_risikoinventar_hist_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_risikoinventar_hist.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_risikoinventar_hist. Return PK.
*
* @param       pior_isr_oam_risikoinventar  IN OUT isr_oam_risikoinventar_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_risikoinventar_hist in out isr_oam_risikoinventar_hist%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_risikoinventar_hist%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_risikoinventar_hist%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_risikoinventar_hist_dml;
/

