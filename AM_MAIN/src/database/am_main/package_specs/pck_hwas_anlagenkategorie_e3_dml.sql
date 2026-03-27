create or replace package am_main.pck_hwas_anlagenkategorie_e3_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_anlagenkategorie_e3.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_anlagenkategorie_e3. Return PK.
*
* @param       pior_hwas_anlagenkategorie_e3  IN OUT hwas_anlagenkategorie_e3%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_anlagenkategorie_e3 in out hwas_anlagenkategorie_e3%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_anlagenkategorie_e3. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_anlagenkategorie_e3   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_anlagenkategorie_e3 in hwas_anlagenkategorie_e3%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_anlagenkategorie_e3.
*
* @param       pir_hwas_anlagenkategorie_e3  IN hwas_anlagenkategorie_e3%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_anlagenkategorie_e3 in hwas_anlagenkategorie_e3%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_anlagenkategorie_e3.
*
* @param       pin_ak3_uid IN hwas_anlagenkategorie_e3.ak3_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ak3_uid in hwas_anlagenkategorie_e3.ak3_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_anlagenkategorie_e3%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_anlagenkategorie_e3%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

---------------------------------------------------------------------------------------------------

end pck_hwas_anlagenkategorie_e3_dml;
/


-- sqlcl_snapshot {"hash":"cbeb5cc75d913f24f8bf918327aed6c975a844ac","type":"PACKAGE_SPEC","name":"PCK_HWAS_ANLAGENKATEGORIE_E3_DML","schemaName":"AM_MAIN","sxml":""}