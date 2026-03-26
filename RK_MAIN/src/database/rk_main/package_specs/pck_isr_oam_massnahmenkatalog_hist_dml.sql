create or replace package rk_main.pck_isr_oam_massnahmenkatalog_hist_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ISR_OAM_MASSNAHMENKATALOG_hist.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ISR_OAM_MASSNAHMENKATALOG_hist. Return PK.
*
* @param       pior_MASSNAHMENKATALOG_hist  IN OUT ISR_OAM_MASSNAHMENKATALOG_hist%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_massnahmenkatalog_hist in out isr_oam_massnahmenkatalog_hist%rowtype
    );

end pck_isr_oam_massnahmenkatalog_hist_dml;
/


-- sqlcl_snapshot {"hash":"6903d02f8b2884159a4aa5a69c9d68da4a53b888","type":"PACKAGE_SPEC","name":"PCK_ISR_OAM_MASSNAHMENKATALOG_HIST_DML","schemaName":"RK_MAIN","sxml":""}