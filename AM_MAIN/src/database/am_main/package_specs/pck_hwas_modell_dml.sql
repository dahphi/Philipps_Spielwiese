create or replace package am_main.pck_hwas_modell_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_modell.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_modell. Return PK.
*
* @param       pior_hwas_modell  IN OUT hwas_modell%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_modell in out hwas_modell%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_modell. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_modell   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_modell in hwas_modell%rowtype,
        piv_art         in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_modell.
*
* @param       pir_hwas_modell  IN hwas_modell%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_modell in hwas_modell%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_modell.
*
* @param       pin_mdl_uid IN hwas_modell.mdl_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_mdl_uid in hwas_modell.mdl_uid%type
    );

---------------------------------------------------------------------------------------------------

  /**
* Insert des uebergebenen Records in Tabelle hwas_modell. Return PK.
*
* @param       pior_hwas_modell  IN OUT hwas_modell%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert_hwdb_modell;

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_modell%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_modell%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_modell_dml;
/


-- sqlcl_snapshot {"hash":"d36d6e30ea81fb0bd2e4169773feb4fe266c4771","type":"PACKAGE_SPEC","name":"PCK_HWAS_MODELL_DML","schemaName":"AM_MAIN","sxml":""}