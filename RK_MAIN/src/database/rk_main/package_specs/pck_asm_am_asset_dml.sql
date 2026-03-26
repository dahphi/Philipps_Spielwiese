create or replace package rk_main.pck_asm_am_asset_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle asm_am_asset.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle asm_am_asset. Return PK.
*
* @param       pior_asm_am_asset  IN OUT asm_am_asset%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_asm_am_asset in out asm_am_asset%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle asm_am_asset. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_asm_am_asset   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_asm_am_asset in asm_am_asset%rowtype,
        piv_art          in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle asm_am_asset.
*
* @param       pir_asm_am_asset  IN asm_am_asset%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_asm_am_asset in asm_am_asset%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle asm_am_asset.
*
* @param       pin_ass_uid IN asm_am_asset.ass_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ass_uid in asm_am_asset.ass_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN asm_am_asset%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in asm_am_asset%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_asm_am_asset_dml;
/


-- sqlcl_snapshot {"hash":"5f3b33d10d36ec22b07e6d0e620027b21e71624c","type":"PACKAGE_SPEC","name":"PCK_ASM_AM_ASSET_DML","schemaName":"RK_MAIN","sxml":""}