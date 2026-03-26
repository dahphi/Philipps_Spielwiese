create or replace package am_main.pck_hwas_infclustertyp_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle HWAS_INFCLUSTERTYP. ICT_UID
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle HWAS_INFCLUSTERTYP. Return PK.
*
* @param       pior_HWAS_INFORMATIONSCLUSTER  IN OUT HWAS_INFCLUSTERTYP%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_hwas_infclustertyp in out hwas_infclustertyp%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle HWAS_INFCLUSTERTYP. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_INFCLUSTERTYP   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_hwas_infclustertyp in hwas_infclustertyp%rowtype,
        piv_art                in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle HWAS_INFCLUSTERTYP.
*
* @param       pir_HWAS_INFCLUSTERTYP IN HWAS_INFCLUSTERTYP%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_hwas_infclustertyp in hwas_infclustertyp%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle HWAS_INFCLUSTERTYP.
*
* @param       pin_nseg_uid IN HWAS_INFCLUSTERTYP.ICT_UID
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_ict_uid in hwas_infclustertyp.ict_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN HWAS_INFCLUSTERTYP%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in hwas_infclustertyp%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_hwas_infclustertyp_dml;
/


-- sqlcl_snapshot {"hash":"fd1d121b53a1e8d4610684556a17772091fe0301","type":"PACKAGE_SPEC","name":"PCK_HWAS_INFCLUSTERTYP_DML","schemaName":"AM_MAIN","sxml":""}