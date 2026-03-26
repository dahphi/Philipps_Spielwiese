-- liquibase formatted sql
-- changeset RK_MAIN:1774555712595 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_iso_27001_mapping_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_iso_27001_mapping_dml.sql:null:04b57379d495e16ebbf53b54821f3cd18a597bc2:create

create or replace package rk_main.pck_isr_iso_27001_mapping_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle ISR_ISO_27001_MAPPING.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle ISR_ISO_27001_MAPPING. Return PK.
*
* @param       pior_ISR_ISO_27001_MAPPING  IN OUT ISR_ISO_27001_MAPPING%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_iso_27001_mapping in out isr_iso_27001_mapping%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle ISR_ISO_27001_MAPPING. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_ISR_ISO_27001_MAPPING   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_iso_27001_mapping in isr_iso_27001_mapping%rowtype,
        piv_art                   in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle ISR_ISO_27001_MAPPING.
*
* @param       pir_ISR_ISO_27001_MAPPING  IN ISR_ISO_27001_MAPPING%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_iso_27001_mapping in isr_iso_27001_mapping%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle ISR_ISO_27001_MAPPING.
*
* @param       pin_I2C_MAP_UID IN ISR_ISO_27001_MAPPING.I2C_MAP_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_i2c_map_uid in isr_iso_27001_mapping.i2c_map_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN ISR_ISO_27001_MAPPING%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_iso_27001_mapping%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_iso_27001_mapping_dml;
/

