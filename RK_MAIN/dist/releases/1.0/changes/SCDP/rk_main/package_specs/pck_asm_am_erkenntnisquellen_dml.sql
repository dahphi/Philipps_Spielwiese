-- liquibase formatted sql
-- changeset RK_MAIN:1774561693994 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_asm_am_erkenntnisquellen_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_asm_am_erkenntnisquellen_dml.sql:null:39c1b063329785b838c7985a6e3ce66ed2e8ca1e:create

create or replace package rk_main.pck_asm_am_erkenntnisquellen_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle asm_am_erkenntnisquellen.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle asm_am_erkenntnisquellen. Return PK.
*
* @param       pior_asm_am_erkenntnisquellen  IN OUT asm_am_erkenntnisquellen%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_asm_am_erkenntnisquellen in out asm_am_erkenntnisquellen%rowtype
    );

  --amtden EDIT--
    procedure p_insert (
        pi_rsk_uid in isr_risiko_erkenntnisquelle.rsk_uid%type,
        pi_ekq_uid in isr_risiko_erkenntnisquelle.ekq_uid%type
    );

    procedure p_delete (
        pi_rsk_uid in isr_risiko_erkenntnisquelle.rsk_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle asm_am_erkenntnisquellen. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_asm_am_erkenntnisquellen   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_asm_am_erkenntnisquellen in asm_am_erkenntnisquellen%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle asm_am_erkenntnisquellen.
*
* @param       pir_asm_am_erkenntnisquellen  IN asm_am_erkenntnisquellen%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_asm_am_erkenntnisquellen in asm_am_erkenntnisquellen%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle asm_am_erkenntnisquellen.
*
* @param       pin_ekq_uid IN asm_am_erkenntnisquellen.ekq_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ekq_uid in asm_am_erkenntnisquellen.ekq_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN asm_am_erkenntnisquellen%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in asm_am_erkenntnisquellen%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_asm_am_erkenntnisquellen_dml;
/

