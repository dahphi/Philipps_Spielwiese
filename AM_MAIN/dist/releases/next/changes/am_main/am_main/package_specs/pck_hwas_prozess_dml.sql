-- liquibase formatted sql
-- changeset AM_MAIN:1774605608135 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_prozess_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_prozess_dml.sql:1d5ea4a6404ec57222a9ec2e1cabd2a3f5610972:45ad5ca7c49c9275708cd371a35fa007fc8dec1b:alter

create or replace package am_main.pck_hwas_prozess_dml as
/**
* Netcologne<br/>
* All rights reserved.<br/><br/>
*
* DML-Routinen zu Tabelle hwas_prozess.
*
*/

    -- MERGE für INSERT & UPDATE eines Prozesstyps
    procedure p_merge_prozesstyp (
        p_prz_uid      in out nocopy hwas_prozesstyp.prz_uid%type,
        p_name         in hwas_prozesstyp.name%type,
        p_beschreibung in hwas_prozesstyp.beschreibung%type,
        p_user         in hwas_prozesstyp.inserted_by%type
    );

    -- DELETE Prozedur
    procedure p_delete_prozesstyp (
        p_prz_uid in hwas_prozesstyp.prz_uid%type
    );

    procedure p_merge_prozessstufe (
        p_przs_uid        in out nocopy hwas_prozessstufe.przs_uid%type,
        p_prz_uid         in hwas_prozessstufe.prz_uid%type,
        p_parent_przs_uid in hwas_prozessstufe.parent_przs_uid%type,
        p_name            in hwas_prozessstufe.name%type,
        p_beschreibung    in hwas_prozessstufe.beschreibung%type,
        p_user            in hwas_prozessstufe.inserted_by%type
    );

    procedure p_delete_prozessstufe (
        p_przs_uid in hwas_prozessstufe.przs_uid%type
    );

    procedure p_merge_prozess (
        p_przp_uid             in out nocopy hwas_prozess.przp_uid%type,
        p_przs_uid             in hwas_prozess.przs_uid%type,
        p_name                 in hwas_prozess.name%type,
        p_beschreibung         in hwas_prozess.beschreibung%type,
        p_user                 in hwas_prozess.inserted_by%type,
        p_link_zum_fremdsystem in hwas_prozess.link_zum_fremdsystem%type,
        p_kriris_relevant      in hwas_prozess.kritis_relevant%type,
        p_prozess_owner        in hwas_prozess.prozess_owner%type,
        p_gek_lfd_nr_fk        in hwas_prozess.gek_lfd_nr_fk%type,
        p_fbk_uid_fk           in hwas_prozess.fbk_uid_fk%type
    );

    procedure p_delete_prozess (
        p_przp_uid in hwas_prozess.przp_uid%type
    );

--Merge Prozess System/Anwendung

    procedure merge_prozess_system (
        p_rec      in hwas_prozess_system%rowtype,
        p_asy_list in varchar2
    );

--Merge Prozess/BSI Baustein
    procedure merge_bsi_bausteine (
        p_przp_uid     in number,
        p_bsi_uid_list in varchar2,
        p_user         in varchar2 default nvl(
            v('APP_USER'),
            user
        )
    );

end pck_hwas_prozess_dml;
/

