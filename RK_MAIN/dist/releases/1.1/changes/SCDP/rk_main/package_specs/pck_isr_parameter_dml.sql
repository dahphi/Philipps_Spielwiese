-- liquibase formatted sql
-- changeset RK_MAIN:1774555712773 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_parameter_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_parameter_dml.sql:null:b440153cc5b3d5465b3a0c1c421427056fd6a84d:create

create or replace package rk_main.pck_isr_parameter_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_parameter.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_parameter. Return PK.
*
* @param       pior_isr_parameter  IN OUT isr_parameter%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_parameter in out isr_parameter%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_parameter. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_parameter   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_parameter in isr_parameter%rowtype,
        piv_art           in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_parameter.
*
* @param       pir_isr_parameter  IN isr_parameter%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_parameter in isr_parameter%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_parameter.
*
* @param       pin_par_uid IN isr_parameter.par_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_par_uid in isr_parameter.par_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_parameter%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_parameter%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_parameter_dml;
/

