create or replace package rk_main.pck_isr_oam_massnahme_hist_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ISR_OAM_MASSNAHME_HIST.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ISR_OAM_MASSNAHME_HIST. Return PK.
*
* @param       pior_ISR_OAM_MASSNAHME_HIST  IN OUT ISR_OAM_MASSNAHME_HIST%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_oam_massnahme_hist in out isr_oam_massnahme_hist%rowtype
    );


---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN ISR_OAM_MASSNAHME_HIST%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_oam_massnahme_hist%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_massnahme_hist_dml;
/


-- sqlcl_snapshot {"hash":"8b992859dd63f0567944d5e1272cf469485e6de8","type":"PACKAGE_SPEC","name":"PCK_ISR_OAM_MASSNAHME_HIST_DML","schemaName":"RK_MAIN","sxml":""}