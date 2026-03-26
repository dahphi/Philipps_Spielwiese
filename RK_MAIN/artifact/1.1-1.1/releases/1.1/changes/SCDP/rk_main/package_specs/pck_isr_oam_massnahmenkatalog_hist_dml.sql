-- liquibase formatted sql
-- changeset RK_MAIN:1774555712681 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_massnahmenkatalog_hist_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_massnahmenkatalog_hist_dml.sql:null:6903d02f8b2884159a4aa5a69c9d68da4a53b888:create

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

