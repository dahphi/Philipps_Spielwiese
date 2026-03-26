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


-- sqlcl_snapshot {"hash":"5acc64a425864aff87b226b4b75300ddce2233be","type":"PACKAGE_SPEC","name":"PCK_ISR_OAM_RISIKOINVENTAR_HIST_DML","schemaName":"RK_MAIN","sxml":""}