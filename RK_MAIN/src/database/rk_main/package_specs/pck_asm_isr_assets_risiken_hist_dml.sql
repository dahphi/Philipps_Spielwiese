create or replace package rk_main.pck_asm_isr_assets_risiken_hist_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ASM_ISR_ASSETS_RISIKEN_HIST.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ASM_ISR_ASSETS_RISIKEN_HIST. Return PK.
*
* @param       pior_ASSETS_RISIKEN_hist  IN OUT ASM_ISR_ASSETS_RISIKEN_HIST%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_assets_risiken_hist in out asm_isr_assets_risiken_hist%rowtype
    );

end pck_asm_isr_assets_risiken_hist_dml;
/


-- sqlcl_snapshot {"hash":"ae057d5df054d326897b405dd075b8f3f277e137","type":"PACKAGE_SPEC","name":"PCK_ASM_ISR_ASSETS_RISIKEN_HIST_DML","schemaName":"RK_MAIN","sxml":""}