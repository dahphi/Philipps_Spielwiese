create or replace package am_main.pck_hwas_gebaeude_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_gebaeude.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_gebaeude. Return PK.
*
* @param       pior_hwas_gebaeude  IN OUT hwas_gebaeude%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_gebaeude in out hwas_gebaeude%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_gebaeude. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_gebaeude   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_gebaeude in hwas_gebaeude%rowtype,
        piv_art           in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_gebaeude.
*
* @param       pir_hwas_gebaeude  IN hwas_gebaeude%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_gebaeude in hwas_gebaeude%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_gebaeude.
*
* @param       pin_geb_uid IN hwas_gebaeude.geb_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_geb_uid in hwas_gebaeude.geb_uid%type
    );
--------------------------------------------------------------------------------------------------
  /**
* Insert des uebergebenen Records in Tabelle HWAS_HERSTELLER. Return PK.
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert_itwo_site;

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_gebaeude%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_gebaeude%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_gebaeude_dml;
/


-- sqlcl_snapshot {"hash":"3b0ea581fda2b6b267e645c01c63f11d52ce24a7","type":"PACKAGE_SPEC","name":"PCK_HWAS_GEBAEUDE_DML","schemaName":"AM_MAIN","sxml":""}