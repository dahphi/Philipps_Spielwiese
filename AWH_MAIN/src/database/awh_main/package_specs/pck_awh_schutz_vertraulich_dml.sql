create or replace package awh_main.pck_awh_schutz_vertraulich_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle AWH_TAB_SCHUTZ_VERTRAULICH. VET_LFD_NR
*
*/

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_VERTRAULICH. Return PK.
*
* @param       pior_HWAS_NETZWERKZONE  IN OUT AWH_TAB_SCHUTZ_VERTRAULICH%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pior_schutz_vertraulich in out awh_tab_schutz_vertraulich%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle AWH_TAB_SCHUTZ_VERTRAULICH. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_HWAS_NETZWERKZONE   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_schutz_vertraulich in awh_tab_schutz_vertraulich%rowtype,
        piv_art                in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Merge des uebergebenen Records in Tabelle AWH_TAB_SCHUTZ_VERTRAULICH.
*
* @param       pir_HWAS_NETZWERKZONE  IN AWH_TAB_SCHUTZ_VERTRAULICH%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_merge (
        pir_schutz_vertraulich in awh_tab_schutz_vertraulich%rowtype
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle AWH_TAB_SCHUTZ_VERTRAULICH.
*
* @param       pin_nseg_uid IN AWH_TAB_SCHUTZ_VERTRAULICH.VET_LFD_NR
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete (
        pin_vet_lfd_nr in awh_tab_schutz_vertraulich.vet_lfd_nr%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN AWH_TAB_SCHUTZ_VERTRAULICH%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_row         in awh_tab_schutz_vertraulich%rowtype,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_awh_schutz_vertraulich_dml;
/


-- sqlcl_snapshot {"hash":"8c9ce7f4caf2b9d7689b654431b7e9085d34328f","type":"PACKAGE_SPEC","name":"PCK_AWH_SCHUTZ_VERTRAULICH_DML","schemaName":"AWH_MAIN","sxml":""}