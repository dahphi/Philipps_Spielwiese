create or replace package am_main.pck_hwas_funktionsklasse_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_funktionsklasse.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_funktionsklasse. Return PK.
*
* @param       pior_hwas_funktionsklasse  IN OUT hwas_funktionsklasse%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_funktionsklasse in out hwas_funktionsklasse%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_funktionsklasse. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_funktionsklasse   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_funktionsklasse in hwas_funktionsklasse%rowtype,
        piv_art                  in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_funktionsklasse.
*
* @param       pir_hwas_funktionsklasse  IN hwas_funktionsklasse%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_funktionsklasse in hwas_funktionsklasse%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_funktionsklasse.
*
* @param       pin_fkl_uid IN hwas_funktionsklasse.fkl_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_fkl_uid in hwas_funktionsklasse.fkl_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_funktionsklasse%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_funktionsklasse%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_funktionsklasse_dml;
/


-- sqlcl_snapshot {"hash":"fa1eb6b368d0e698d6ad274e80c9e2f94025f54e","type":"PACKAGE_SPEC","name":"PCK_HWAS_FUNKTIONSKLASSE_DML","schemaName":"AM_MAIN","sxml":""}