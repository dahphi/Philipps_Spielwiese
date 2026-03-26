-- liquibase formatted sql
-- changeset RK_MAIN:1774555712483 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_asm_isr_assets_risiken_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_asm_isr_assets_risiken_dml.sql:null:99ad1a173e06fc812aed3dd7e6b36fb2828bfe17:create

create or replace package rk_main.pck_asm_isr_assets_risiken_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle asm_isr_assets_risiken.
*
*/

    type rsk_asm_isr_assets_risiken is record (
            asri_uid    asm_isr_assets_risiken.asri_uid%type,
            rsk_uid     asm_isr_assets_risiken.rsk_uid%type,
            assets      varchar2(4000),
            inserted    asm_isr_assets_risiken.inserted%type,
            inserted_by asm_isr_assets_risiken.inserted_by%type,
            updated     asm_isr_assets_risiken.updated%type,
            updated_by  asm_isr_assets_risiken.updated_by%type
    );
    type ass_asm_isr_assets_risiken is record (
            asri_uid    asm_isr_assets_risiken.asri_uid%type,
            ass_uid     asm_isr_assets_risiken.ass_uid%type,
            risiken     varchar2(4000),
            inserted    asm_isr_assets_risiken.inserted%type,
            inserted_by asm_isr_assets_risiken.inserted_by%type,
            updated     asm_isr_assets_risiken.updated%type,
            updated_by  asm_isr_assets_risiken.updated_by%type
    );

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle asm_isr_assets_risiken. Return PK.
*
* @param       pior_asm_isr_assets_risiken  IN OUT asm_isr_assets_risiken%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken
    );

    procedure p_insert (
        pir_ass_asm_isr_assets_risiken in ass_asm_isr_assets_risiken
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle asm_isr_assets_risiken. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_asm_isr_assets_risiken   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken,
        piv_art                        in varchar2
    );
            --Version mit Friedhof, wurde gemacht damit keine Assetverbindungen verloren gehen.
    procedure p_update (
        pir_rsk_asm_isr_assets_risiken in rsk_asm_isr_assets_risiken,
        piv_art                        in varchar2,
        piv_friedhof                   in number
    );

    procedure p_update (
        pir_ass_asm_isr_assets_risiken in ass_asm_isr_assets_risiken,
        piv_art                        in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle asm_isr_assets_risiken.
*
* @param       pin_asri_uid IN asm_isr_assets_risiken.asri_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete_for_rsk (
        pin_rsk_uid in asm_isr_assets_risiken.rsk_uid%type
    );

    procedure p_delete_for_ass (
        pin_ass_uid in asm_isr_assets_risiken.ass_uid%type
    );

    procedure p_delete_for_rsk_ass (
        pin_ass_uid in asm_isr_assets_risiken.ass_uid%type,
        pin_rsk_uid in asm_isr_assets_risiken.rsk_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN asm_isr_assets_risiken%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_rsk         in rsk_asm_isr_assets_risiken,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

    function fv_print (
        pir_ass         in ass_asm_isr_assets_risiken,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_asm_isr_assets_risiken_dml;
/

