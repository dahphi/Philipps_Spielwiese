-- liquibase formatted sql
-- changeset RK_MAIN:1774555712674 stripComments:false logicalFilePath:SCDP/rk_main/package_specs/pck_isr_oam_massnahmenkatalog_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/package_specs/pck_isr_oam_massnahmenkatalog_dml.sql:null:8d35100288d594bb594f2a82b7b77ac194e578f5:create

create or replace package rk_main.pck_isr_oam_massnahmenkatalog_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle isr_oam_massnahmenkatalog.
*
*/

    type rsk_isr_oam_massnahmenkatalog is record (
            mnk_uid     isr_oam_massnahmenkatalog.mnk_uid%type,
            rsk_uid     isr_oam_massnahmenkatalog.rsk_uid%type,
            massnahmen  varchar2(4000),
            inserted    isr_oam_massnahmenkatalog.inserted%type,
            inserted_by isr_oam_massnahmenkatalog.inserted_by%type,
            updated     isr_oam_massnahmenkatalog.updated%type,
            updated_by  isr_oam_massnahmenkatalog.updated_by%type
    );
    type msn_isr_oam_massnahmenkatalog is record (
            mnk_uid     isr_oam_massnahmenkatalog.mnk_uid%type,
            msn_uid     isr_oam_massnahmenkatalog.msn_uid%type,
            risiken     varchar2(4000),
            inserted    isr_oam_massnahmenkatalog.inserted%type,
            inserted_by isr_oam_massnahmenkatalog.inserted_by%type,
            updated     isr_oam_massnahmenkatalog.updated%type,
            updated_by  isr_oam_massnahmenkatalog.updated_by%type
    );

---------------------------------------------------------------------------------------------------

/**
* Insert des uebergebenen Records in Tabelle isr_oam_massnahmenkatalog. Return PK.
*
* @param       pior_isr_oam_massnahmenkatalog  IN OUT isr_oam_massnahmenkatalog%ROWTYPE
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_insert (
        pir_rsk_isr_oam_massnahmenkatalog in rsk_isr_oam_massnahmenkatalog
    );

    procedure p_insert (
        pir_msn_isr_oam_massnahmenkatalog in msn_isr_oam_massnahmenkatalog
    );

    procedure p_insert_in_katalog (
        p_rsk_uid in number,
        p_msn_uid in number
    );

---------------------------------------------------------------------------------------------------

/**
* Update Tabelle isr_oam_massnahmenkatalog. Zentrale Update-Routine, die von allen anderen Update-Routinen aufgerufen wird.
*
* @param       pir_isr_oam_massnahmenkatalog   => Record, der upgedatet werden soll
* @param       piv_art               => Unterscheidung was upgedatet werden soll
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_update (
        pir_rsk_isr_oam_massnahmenkatalog in rsk_isr_oam_massnahmenkatalog,
        piv_art                           in varchar2
    );

    procedure p_update (
        pir_msn_isr_oam_massnahmenkatalog in msn_isr_oam_massnahmenkatalog,
        piv_art                           in varchar2
    );

---------------------------------------------------------------------------------------------------

/**
* Mittels uebergebenen PK delete Record aus Tabelle isr_oam_massnahmenkatalog.
*
* @param       pin_mnk_uid IN isr_oam_massnahmenkatalog.mnk_uid
*
* @throws      Fehler werden per RAISE weitergerreicht
*/
    procedure p_delete_for_rsk (
        pin_rsk_uid in isr_oam_massnahmenkatalog.rsk_uid%type
    );

    procedure p_delete_for_msn (
        pin_msn_uid in isr_oam_massnahmenkatalog.msn_uid%type
    );

    procedure p_delete_for_msn_rsk (
        pin_msn_uid in isr_oam_massnahmenkatalog.msn_uid%type,
        pin_rsk_uid in isr_oam_massnahmenkatalog.rsk_uid%type
    );

---------------------------------------------------------------------------------------------------

/**
* Liefert Record-Variablen inkl. Werten zum Uebergabe-Record als String.
*
* @param       pir_row          IN isr_oam_massnahmenkatalog%ROWTYPE
* @param       piv_output_type  IN VARCHAR2 DEFAULT 'no'
*              <li> 'no': kommaseparierte Liste ohne Zeilenumbruch </li>
*              <li> 'pretty': kommaseparierte Liste mit Zeilenumbruch </li>
*              <li> 'html': html-table </li>
*
*/
    function fv_print (
        pir_rsk         in rsk_isr_oam_massnahmenkatalog,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

    function fv_print (
        pir_msn         in msn_isr_oam_massnahmenkatalog,
        piv_output_type in varchar2 default 'no'
    ) return varchar2;

end pck_isr_oam_massnahmenkatalog_dml;
/

