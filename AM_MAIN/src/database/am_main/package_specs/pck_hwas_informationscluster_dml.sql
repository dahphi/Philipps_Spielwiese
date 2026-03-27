create or replace package am_main.pck_hwas_informationscluster_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle HWAS_INFORMATIONSCLUSTER. INCL_UID
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle HWAS_INFORMATIONSCLUSTER. Return PK.
*
* @param       pior_HWAS_INFORMATIONSCLUSTER  IN OUT HWAS_INFORMATIONSCLUSTER%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_informationscluster in out hwas_informationscluster%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle HWAS_INFORMATIONSCLUSTER. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_INFORMATIONSCLUSTER   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_informationscluster in hwas_informationscluster%rowtype,
        piv_art                      in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle HWAS_INFORMATIONSCLUSTER.
*
* @param       pir_HWAS_INFORMATIONSCLUSTER IN HWAS_INFORMATIONSCLUSTER%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_informationscluster in hwas_informationscluster%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle HWAS_INFORMATIONSCLUSTER.
*
* @param       pin_nseg_uid IN HWAS_INFORMATIONSCLUSTER.INCL_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_incl_uid in hwas_informationscluster.incl_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN HWAS_INFORMATIONSCLUSTER%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_informationscluster%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_informationscluster_dml;
/


-- sqlcl_snapshot {"hash":"68e5692ab04467b19e605664d92b92c540ac7c8d","type":"PACKAGE_SPEC","name":"PCK_HWAS_INFORMATIONSCLUSTER_DML","schemaName":"AM_MAIN","sxml":""}