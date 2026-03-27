create or replace package am_main.pck_hwas_informationsdomaene_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle HWAS_INFORMATIONSDOMAENE. DOM_UID
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle HWAS_INFORMATIONSDOMAENE. Return PK.
*
* @param       pior_HWAS_INFORMATIONSCLUSTER  IN OUT HWAS_INFORMATIONSDOMAENE%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_informationsdomaene in out hwas_informationsdomaene%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle HWAS_INFORMATIONSDOMAENE. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_INFORMATIONSCLUSTER   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_informationsdomaene in hwas_informationsdomaene%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle HWAS_INFORMATIONSDOMAENE.
*
* @param       pir_HWAS_INFORMATIONSCLUSTER IN HWAS_INFORMATIONSDOMAENE%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_informationsdomaene in hwas_informationsdomaene%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle HWAS_INFORMATIONSDOMAENE.
*
* @param       pin_nseg_uid IN HWAS_INFORMATIONSDOMAENE.DOM_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_dom_uid in hwas_informationsdomaene.dom_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN HWAS_INFORMATIONSDOMAENE%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_informationsdomaene%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_informationsdomaene_dml;
/


-- sqlcl_snapshot {"hash":"357c82cc0107597a98aa40d83087523248cf2a93","type":"PACKAGE_SPEC","name":"PCK_HWAS_INFORMATIONSDOMAENE_DML","schemaName":"AM_MAIN","sxml":""}