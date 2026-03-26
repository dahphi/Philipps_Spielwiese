create or replace package rk_main.pck_isr_brm_elem_gefaehrdung_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_brm_elem_gefaehrdung.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_brm_elem_gefaehrdung. Return PK.
*
* @param       pior_isr_brm_elem_gefaehrdung  IN OUT isr_brm_elem_gefaehrdung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_isr_brm_elem_gefaehrdung in out isr_brm_elem_gefaehrdung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_brm_elem_gefaehrdung. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_brm_elem_gefaehrdung   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_isr_brm_elem_gefaehrdung in isr_brm_elem_gefaehrdung%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle isr_brm_elem_gefaehrdung.
*
* @param       pir_isr_brm_elem_gefaehrdung  IN isr_brm_elem_gefaehrdung%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_isr_brm_elem_gefaehrdung in isr_brm_elem_gefaehrdung%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_brm_elem_gefaehrdung.
*
* @param       pin_ege_uid IN isr_brm_elem_gefaehrdung.ege_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ege_uid in isr_brm_elem_gefaehrdung.ege_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_brm_elem_gefaehrdung%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in isr_brm_elem_gefaehrdung%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_brm_elem_gefaehrdung_dml;
/


-- sqlcl_snapshot {"hash":"5cdb1c11d5db5493d217dddb4110a8656bc156f4","type":"PACKAGE_SPEC","name":"PCK_ISR_BRM_ELEM_GEFAEHRDUNG_DML","schemaName":"RK_MAIN","sxml":""}