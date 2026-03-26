-- liquibase formatted sql
-- changeset AM_MAIN:1774557120263 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_hwas_vertragsmanagement.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_vertragsmanagement.sql:null:f21a7848e0fe8c101a59a7898fd10ad88a27d526:create

create or replace package am_main.pck_hwas_vertragsmanagement as

  -- Merge eines einzelnen Geschäftskunden-Datensatzes
    procedure merge_geschaeftskunde (
        p_row  in hwas_geschaeftskunden%rowtype,
        p_user in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

  -- Löschen per Primärschlüssel
    procedure delete_geschaeftskunde (
        p_gesku_uid in number
    );

  --Verträge
    procedure merge_vertrag (
        p_row  in out nocopy hwas_vertrag%rowtype,
        p_user in varchar2
    );
  --Promotion
    procedure merge_promotion (
        p_row  in out nocopy hwas_promotion%rowtype,
        p_user in varchar2
    );

    procedure delete_promotion (
        p_prom_uid in hwas_promotion.prom_uid%type
    );

    -- Produkte
    procedure merge_produkt (
        p_row in hwas_produkt%rowtype
    );

    procedure delete_produkt (
        p_prod_uid in number
    );

   -- Vertragsdetails (Relation Vertrag <-> Produkt) erstmal obsolet
    procedure sync_vertrag_produkte (
        p_vert_uid  in number,
        p_prod_list in varchar2,
        p_user      in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

    procedure sync_asset_vertragsdetails (
        p_ass_uid in number,
        p_vd_list in varchar2,
        p_user    in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

    procedure delete_asset_relations (
        p_ass_uid in number
    );

--Merge Produktlinie
    procedure merge_produktlinie (
        p_rec in hwas_produktlinie%rowtype
    );

    procedure delete_produktlinie (
        p_rec in hwas_produktlinie%rowtype
    );
--Merge Vertrags_Titel
    procedure merge_vertrag_titel (
        p_rec in hwas_vertrag_titel%rowtype
    );

    procedure delete_vertrag_titel (
        p_rec in hwas_vertrag_titel%rowtype
    );

  --Merge Produktbestandteil
    procedure merge_produktbestandteil (
        p_rec in hwas_produktbestandteil%rowtype
    );

    procedure delete_produktbestandteil (
        p_rec in hwas_produktbestandteil%rowtype
    );

  --Merge VERTRAG_PRODUKT
    procedure merge_vertrag_produkt (
        p_row  in out hwas_vertrag_produkt%rowtype,
        p_user in varchar2 default null
    );

    procedure delete_vertrag_produkt (
        p_ver_prod_uid in hwas_vertrag_produkt.ver_prod_uid%type
    );

  --Merge Vertragsdetails
    procedure merge_vertragsdetails (
        p_rec in hwas_vertragsdetails%rowtype
    );

    procedure delete_vertragsdetails (
        p_rec in hwas_vertragsdetails%rowtype
    );

  -- MERGE Vertragsdetial zu Assets
    procedure merge_lieferant_vertragsdetail (
        p_rec     in hwas_lieferant_vertragsdetail%rowtype,
        p_vd_list in varchar2
    );
 -- Merge Vertragsdetail zu Prozess
    procedure merge_prozess_vertragsdetail (
        p_rec     in hwas_prozesse_vertragsdetails%rowtype,
        p_vd_list in varchar2
    );

  --Merge Prozesse zu Anwendungen
    procedure merge_awh_eb3 (
        p_przp_uid_fk in number,
        p_asy_list    in varchar2,
        p_user        in varchar2 default null
    );

end pck_hwas_vertragsmanagement;
/

