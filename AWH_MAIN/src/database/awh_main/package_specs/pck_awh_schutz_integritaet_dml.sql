create or replace package awh_main.pck_awh_schutz_integritaet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle AWH_TAB_SCHUTZ_INTEGRITAET. INT_LFD_NR
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_INTEGRITAET. Return PK.
*
* @param       pior_HWAS_NETZWERKZONE  IN OUT AWH_TAB_SCHUTZ_INTEGRITAET%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_schutz_integritaet in out awh_tab_schutz_integritaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle AWH_TAB_SCHUTZ_INTEGRITAET. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_SCHUTZ_INTEGRITAET   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_schutz_integritaet in awh_tab_schutz_integritaet%rowtype,
        piv_art                in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_INTEGRITAET.
*
* @param       pir_SCHUTZ_INTEGRITAET IN AWH_TAB_SCHUTZ_INTEGRITAET%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_schutz_integritaet in awh_tab_schutz_integritaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle AWH_TAB_SCHUTZ_INTEGRITAET.
*
* @param       pin_nseg_uid IN AWH_TAB_SCHUTZ_INTEGRITAET.INT_LFD_NR
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_int_lfd_nr in awh_tab_schutz_integritaet.int_lfd_nr%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN AWH_TAB_SCHUTZ_INTEGRITAET%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in awh_tab_schutz_integritaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_awh_schutz_integritaet_dml;
/


-- sqlcl_snapshot {"hash":"c8ecec0281c74b54d5761a12a17437c621f53f13","type":"PACKAGE_SPEC","name":"PCK_AWH_SCHUTZ_INTEGRITAET_DML","schemaName":"AWH_MAIN","sxml":""}