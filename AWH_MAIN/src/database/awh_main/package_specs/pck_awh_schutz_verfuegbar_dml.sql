create or replace package awh_main.pck_awh_schutz_verfuegbar_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle AWH_TAB_SCHUTZ_VERFUEGBAR. VEF_LFD_NR
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_VERFUEGBAR. Return PK.
*
* @param       pior_HWAS_NETZWERKZONE  IN OUT AWH_TAB_SCHUTZ_VERFUEGBAR%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_schutz_verfuegbar in out awh_tab_schutz_verfuegbar%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle AWH_TAB_SCHUTZ_VERFUEGBAR. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_SCHUTZ_VERFUEGBAR   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_schutz_verfuegbar in awh_tab_schutz_verfuegbar%rowtype,
        piv_art               in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_VERFUEGBAR.
*
* @param       pir_SCHUTZ_VERFUEGBAR IN AWH_TAB_SCHUTZ_VERFUEGBAR%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_schutz_verfuegbar in awh_tab_schutz_verfuegbar%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle AWH_TAB_SCHUTZ_VERFUEGBAR.
*
* @param       pin_nseg_uid IN AWH_TAB_SCHUTZ_VERFUEGBAR.VEF_LFD_NR
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_vef_lfd_nr in awh_tab_schutz_verfuegbar.vef_lfd_nr%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN AWH_TAB_SCHUTZ_VERFUEGBAR%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in awh_tab_schutz_verfuegbar%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_awh_schutz_verfuegbar_dml;
/


-- sqlcl_snapshot {"hash":"584b623d69912a3ef1892696e3d3162a0a38220d","type":"PACKAGE_SPEC","name":"PCK_AWH_SCHUTZ_VERFUEGBAR_DML","schemaName":"AWH_MAIN","sxml":""}