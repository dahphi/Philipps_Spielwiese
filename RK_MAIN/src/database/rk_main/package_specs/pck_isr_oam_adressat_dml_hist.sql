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


-- sqlcl_snapshot {"hash":"d8fa2913c4ba7e809f77807e5c74c8d37d856217","type":"PACKAGE_SPEC","name":"PCK_ISR_OAM_ADRESSAT_DML_HIST","schemaName":"RK_MAIN","sxml":""}