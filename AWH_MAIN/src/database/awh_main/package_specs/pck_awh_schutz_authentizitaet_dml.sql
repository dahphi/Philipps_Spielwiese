create or replace package awh_main.pck_awh_schutz_authentizitaet_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle AWH_TAB_SCHUTZ_AUTHENTIZITAET. AUT_LFD_NR
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_AUTHENTIZITAET. Return PK.
*
* @param       pior_HWAS_NETZWERKZONE  IN OUT AWH_TAB_SCHUTZ_AUTHENTIZITAET%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_schutz_authentizitaet in out awh_tab_schutz_authentizitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle AWH_TAB_SCHUTZ_AUTHENTIZITAET. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_SCHUTZ_AUTHENTIZITAET   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_schutz_authentizitaet in awh_tab_schutz_authentizitaet%rowtype,
        piv_art                   in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_AUTHENTIZITAET.
*
* @param       pir_SCHUTZ_AUTHENTIZITAET IN AWH_TAB_SCHUTZ_AUTHENTIZITAET%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_schutz_authentizitaet in awh_tab_schutz_authentizitaet%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle AWH_TAB_SCHUTZ_AUTHENTIZITAET.
*
* @param       pin_nseg_uid IN AWH_TAB_SCHUTZ_AUTHENTIZITAET.AUT_LFD_NR
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_aut_lfd_nr in awh_tab_schutz_authentizitaet.aut_lfd_nr%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN AWH_TAB_SCHUTZ_AUTHENTIZITAET%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in awh_tab_schutz_authentizitaet%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_awh_schutz_authentizitaet_dml;
/


-- sqlcl_snapshot {"hash":"791cb8975f43e7d473385be6f647d2c042cfe5a6","type":"PACKAGE_SPEC","name":"PCK_AWH_SCHUTZ_AUTHENTIZITAET_DML","schemaName":"AWH_MAIN","sxml":""}