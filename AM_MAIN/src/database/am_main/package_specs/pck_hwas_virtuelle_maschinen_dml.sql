create or replace package am_main.pck_hwas_virtuelle_maschinen_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_virtuelle_maschinen.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle hwas_virtuelle_maschinen. Return PK.
*
* @param       pior_hwas_virtuelle_maschinen  IN OUT hwas_virtuelle_maschinen%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_virtuelle_maschinen in out hwas_virtuelle_maschinen%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle hwas_virtuelle_maschinen. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_hwas_virtuelle_maschinen   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_virtuelle_maschinen in hwas_virtuelle_maschinen%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle hwas_virtuelle_maschinen.
*
* @param       pir_hwas_virtuelle_maschinen  IN hwas_virtuelle_maschinen%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_virtuelle_maschinen in hwas_virtuelle_maschinen%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle hwas_virtuelle_maschinen.
*
* @param       pin_vm_uid IN hwas_virtuelle_maschinen.vm_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_vm_uid in hwas_virtuelle_maschinen.vm_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN hwas_virtuelle_maschinen%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_virtuelle_maschinen%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_virtuelle_maschinen_dml;
/


-- sqlcl_snapshot {"hash":"65a078abe067abd111023aa5959cf2213000dd23","type":"PACKAGE_SPEC","name":"PCK_HWAS_VIRTUELLE_MASCHINEN_DML","schemaName":"AM_MAIN","sxml":""}