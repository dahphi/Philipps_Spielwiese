create or replace package am_main.pck_hwas_geraet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_geraet.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_geraet. Return PK.
*
* @param       pior_hwas_geraet  IN OUT hwas_geraet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_geraet in out hwas_geraet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_geraet. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_geraet   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_geraet in hwas_geraet%rowtype,
        piv_art         in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_geraet.
*
* @param       pir_hwas_geraet  IN hwas_geraet%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_geraet in hwas_geraet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_geraet.
*
* @param       pin_grt_uid IN hwas_geraet.grt_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_grt_uid in hwas_geraet.grt_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_geraet%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_geraet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_geraet_dml;
/


-- sqlcl_snapshot {"hash":"b84096afa18d68cd5f1637f4d0fb25585711e4f6","type":"PACKAGE_SPEC","name":"PCK_HWAS_GERAET_DML","schemaName":"AM_MAIN","sxml":""}