create or replace package am_main.pck_hwas_netzwerkzone_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle HWAS_NETZWERKZONE.
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle HWAS_NETZWERKZONE. Return PK.
*
* @param       pior_HWAS_NETZWERKZONE  IN OUT HWAS_NETZWERKZONE%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_netzwerkzone in out hwas_netzwerkzone%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle HWAS_NETZWERKZONE. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_NETZWERKZONE   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_netzwerkzone in hwas_netzwerkzone%rowtype,
        piv_art               in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle HWAS_NETZWERKZONE.
*
* @param       pir_HWAS_NETZWERKZONE  IN HWAS_NETZWERKZONE%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_netzwerkzone in hwas_netzwerkzone%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle HWAS_NETZWERKZONE.
*
* @param       pin_nseg_uid IN HWAS_NETZWERKZONE.NZONE_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_nzone_uid in hwas_netzwerkzone.nzone_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN HWAS_NETZWERKZONE%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_netzwerkzone%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_netzwerkzone_dml;
/


-- sqlcl_snapshot {"hash":"fe832919ecabb9e455a81a0d64dc8aab3e52b5ac","type":"PACKAGE_SPEC","name":"PCK_HWAS_NETZWERKZONE_DML","schemaName":"AM_MAIN","sxml":""}