create or replace package am_main.pck_hwas_kritikalitaet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_kritikalitaet.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_kritikalitaet. Return PK.
*
* @param       pior_hwas_kritikalitaet  IN OUT hwas_kritikalitaet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_kritikalitaet in out hwas_kritikalitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_kritikalitaet. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_kritikalitaet   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_kritikalitaet in hwas_kritikalitaet%rowtype,
        piv_art                in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_kritikalitaet.
*
* @param       pir_hwas_kritikalitaet  IN hwas_kritikalitaet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_kritikalitaet in hwas_kritikalitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_kritikalitaet.
*
* @param       pin_krk_uid IN hwas_kritikalitaet.krk_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_krk_uid in hwas_kritikalitaet.krk_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_kritikalitaet%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_kritikalitaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_kritikalitaet_dml;
/


-- sqlcl_snapshot {"hash":"d3886abd5bb4ce4a87f94b52861942d479e484ed","type":"PACKAGE_SPEC","name":"PCK_HWAS_KRITIKALITAET_DML","schemaName":"AM_MAIN","sxml":""}