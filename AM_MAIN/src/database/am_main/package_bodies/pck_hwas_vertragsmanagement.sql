create or replace package body am_main.pck_hwas_vertragsmanagement as

    procedure merge_geschaeftskunde (
        p_row  in hwas_geschaeftskunden%rowtype,
        p_user in varchar2
    ) is
    begin
        merge into hwas_geschaeftskunden t
        using (
            select
                nvl(p_row.gesku_uid, to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) as gesku_uid,
                p_row.name                                                                            as name,
                p_row.hubspot_datensatz_id                                                            as hubspot_datensatz_id,
                p_row.anspa_info_sicherheitsvorfaelle                                                 as anspa_info_sicherheitsvorfaelle
                ,
                p_row.anspa_info_sicherheit                                                           as anspa_info_sicherheit,
                p_row.anspa_netcologne_geschaeftskunden                                               as anspa_netcologne_geschaeftskunden
                ,
                p_row.confluence_seite                                                                as confluence_seite,
                p_row.bsi_it_grundschutz_relevanz                                                     as bsi_it_grundschutz_relevanz,
                p_row.dora_relevant                                                                   as dora_relevant,
                p_row.kundennr_siebel                                                                 as kundennr_siebel,
                p_row.ansprech_mail                                                                   as ansprech_mail,
                p_row.ansprech_telefon                                                                as ansprech_telefon,
                p_row.kritis_relevant                                                                 as kritis_relevant
            from
                dual
        ) s on ( t.gesku_uid = s.gesku_uid )
        when matched then update
        set t.name = s.name,
            t.hubspot_datensatz_id = s.hubspot_datensatz_id,
            t.anspa_info_sicherheitsvorfaelle = s.anspa_info_sicherheitsvorfaelle,
            t.anspa_info_sicherheit = s.anspa_info_sicherheit,
            t.anspa_netcologne_geschaeftskunden = s.anspa_netcologne_geschaeftskunden,
            t.confluence_seite = s.confluence_seite,
            t.updated = sysdate,
            t.updated_by = p_user,
            t.bsi_it_grundschutz_relevanz = s.bsi_it_grundschutz_relevanz,
            t.dora_relevant = s.dora_relevant,
            t.kundennr_siebel = s.kundennr_siebel,
            t.ansprech_mail = s.ansprech_mail,
            t.ansprech_telefon = s.ansprech_telefon,
            t.kritis_relevant = s.kritis_relevant
        when not matched then
        insert (
            gesku_uid,
            name,
            hubspot_datensatz_id,
            anspa_info_sicherheitsvorfaelle,
            anspa_info_sicherheit,
            anspa_netcologne_geschaeftskunden,
            confluence_seite,
            inserted,
            inserted_by,
            bsi_it_grundschutz_relevanz,
            dora_relevant,
            kundennr_siebel,
            ansprech_mail,
            ansprech_telefon,
            kritis_relevant )
        values
            ( s.gesku_uid,
              s.name,
              s.hubspot_datensatz_id,
              s.anspa_info_sicherheitsvorfaelle,
              s.anspa_info_sicherheit,
              s.anspa_netcologne_geschaeftskunden,
              s.confluence_seite,
              sysdate,
              p_user,
              nvl(s.bsi_it_grundschutz_relevanz, 0),
              s.dora_relevant,
              s.kundennr_siebel,
              s.ansprech_mail,
              s.ansprech_telefon,
              s.kritis_relevant );

    end merge_geschaeftskunde;

--delete
    procedure delete_geschaeftskunde (
        p_gesku_uid in number
    ) is
    begin
        delete from hwas_geschaeftskunden
        where
            gesku_uid = p_gesku_uid;

    end delete_geschaeftskunde;
  
   ---------------------------------------------------------------------------
  --  MERGE_VERTRÄGE
  ---------------------------------------------------------------------------
    procedure merge_vertrag (
        p_row  in out nocopy hwas_vertrag%rowtype,
        p_user in varchar2
    ) is
    begin
    -- PK generieren, wenn neu
        if p_row.vert_uid is null then
            select
                to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
            into p_row.vert_uid
            from
                dual;

        end if;

        merge into hwas_vertrag t
        using (
            select
                p_row.vert_uid             as vert_uid,
                p_row.vertragsname         as vertragsname,
                p_row.gesku_uid_fk         as gesku_uid_fk,
                p_row.gueltig_bis          as gueltig_bis,
                p_row.vertragsstatus       as vertragsstatus,
                p_row.vertragstyp          as vertragstyp,
                p_row.vertragsdokument_url as vertragsdokument_url,
                p_row.vertragsname_kurz    as vertragsname_kurz
            from
                dual
        ) s on ( t.vert_uid = s.vert_uid )
        when matched then update
        set t.vertragsname = s.vertragsname,
            t.gesku_uid_fk = s.gesku_uid_fk,
            t.gueltig_bis = s.gueltig_bis,
            t.vertragsstatus = s.vertragsstatus,
            t.vertragstyp = s.vertragstyp,
            t.vertragsdokument_url = s.vertragsdokument_url,
            t.vertragsname_kurz = s.vertragsname_kurz
        when not matched then
        insert (
            vert_uid,
            vertragsname,
            gesku_uid_fk,
            gueltig_bis,
            vertragsstatus,
            vertragstyp,
            vertragsdokument_url,
            vertragsname_kurz )
        values
            ( s.vert_uid,
              s.vertragsname,
              s.gesku_uid_fk,
              s.gueltig_bis,
              s.vertragsstatus,
              s.vertragstyp,
              s.vertragsdokument_url,
              s.vertragsname_kurz );

    end merge_vertrag;
  
   ---------------------------------------------------------------------------
  --  MERGE_PROMOTION
  ---------------------------------------------------------------------------
    procedure merge_promotion (
        p_row  in out nocopy hwas_promotion%rowtype,
        p_user in varchar2
    ) is
    begin
    -- PK generieren, wenn neu
        if p_row.prom_uid is null then
            select
                to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
            into p_row.prom_uid
            from
                dual;

        end if;

        merge into hwas_promotion t
        using (
            select
                p_row.prom_uid       as prom_uid,
                p_row.name           as name,
                p_row.bemerkung      as bemerkung,
                p_row.prod_ln_uid_fk as prod_ln_uid_fk
            from
                dual
        ) s on ( t.prom_uid = s.prom_uid )
        when matched then update
        set t.name = s.name,
            t.bemerkung = s.bemerkung,
            t.prod_ln_uid_fk = s.prod_ln_uid_fk
        when not matched then
        insert (
            prom_uid,
            name,
            bemerkung,
            prod_ln_uid_fk )
        values
            ( s.prom_uid,
              s.name,
              s.bemerkung,
              s.prod_ln_uid_fk );

    end merge_promotion;

  ---------------------------------------------------------------------------
  -- DELETE_PROMOTION
  ---------------------------------------------------------------------------
    procedure delete_promotion (
        p_prom_uid in hwas_promotion.prom_uid%type
    ) is
    begin
        delete from hwas_promotion
        where
            prom_uid = p_prom_uid;

    end delete_promotion;
  
   ---------------------------------------------------------------------------
  -- Produkte
  ---------------------------------------------------------------------------

    procedure merge_produkt (
        p_row in hwas_produkt%rowtype
    ) is
    begin
        merge into hwas_produkt t
        using (
            select
                nvl(p_row.prod_uid,
          --TO_NUMBER(SYS_GUID(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')
                    to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                    'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')) as prod_uid,
                p_row.name                             as name,
                p_row.beschreibung                     as beschreibung,
                p_row.produktstatus                    as produktstatus,
                p_row.leistungsbeschreibung_url        as leistungsbeschreibung_url,
                p_row.prom_uid_fk                      as prom_uid_fk,
                p_row.prod_owner                       as prod_owner,
                p_row.gesku_uid_fk                     as gesku_uid_fk,
                p_row.tech_ansprechpartner             as tech_ansprechpartner
            from
                dual
        ) s on ( t.prod_uid = s.prod_uid )
        when matched then update
        set t.name = s.name,
            t.beschreibung = s.beschreibung,
            t.produktstatus = s.produktstatus,
            t.leistungsbeschreibung_url = s.leistungsbeschreibung_url,
            t.prom_uid_fk = s.prom_uid_fk,
            t.prod_owner = s.prod_owner,
            t.gesku_uid_fk = s.gesku_uid_fk,
            t.tech_ansprechpartner = s.tech_ansprechpartner
        when not matched then
        insert (
            prod_uid,
            name,
            beschreibung,
            produktstatus,
            leistungsbeschreibung_url,
            prom_uid_fk,
            prod_owner,
            gesku_uid_fk,
            tech_ansprechpartner )
        values
            ( s.prod_uid,
              s.name,
              s.beschreibung,
              s.produktstatus,
              s.leistungsbeschreibung_url,
              s.prom_uid_fk,
              s.prod_owner,
              s.gesku_uid_fk,
              s.tech_ansprechpartner );

    end merge_produkt;

    procedure delete_produkt (
        p_prod_uid in number
    ) is
    begin
        delete from hwas_produkt
        where
            prod_uid = p_prod_uid;

    end delete_produkt;
  
  --VERTRAGSDETAILS

    procedure sync_vertrag_produkte (
        p_vert_uid  in number,
        p_prod_list in varchar2,
        p_user      in varchar2
    ) is
    begin
    ------------------------------------------------------------------
    -- 1) Löschen: alles, was NICHT (mehr) im Shuttle ist
    ------------------------------------------------------------------
        if p_prod_list is null then
      -- Wenn im Shuttle nichts ausgewählt ist: alle Zuordnungen löschen
            delete from hwas_vertragsdetails
            where
                vert_uid_fk = p_vert_uid;

        else
            delete from hwas_vertragsdetails d
            where
                    d.vert_uid_fk = p_vert_uid
                and not exists (
                    select
                        1
                    from
                        (
                            select distinct
                                to_number(trim(regexp_substr(p_prod_list, '[^:]+', 1, level))) as prod_uid
                            from
                                dual
                            connect by
                                regexp_substr(p_prod_list, '[^:]+', 1, level) is not null
                        ) s
                    where
                        s.prod_uid = d.prod_uid_fk
                );

        end if;

    ------------------------------------------------------------------
    -- 2) Einfügen: alles, was im Shuttle ist, aber noch NICHT in der Tabelle
    ------------------------------------------------------------------
        if p_prod_list is not null then
            insert into hwas_vertragsdetails (
                vd_uid,
                prod_uid_fk,
                vert_uid_fk,
                inserted,
                inserted_by
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as vd_uid,
                    s.prod_uid,
                    p_vert_uid,
                    sysdate,
                    p_user
                from
                    (
                        select distinct
                            to_number(trim(regexp_substr(p_prod_list, '[^:]+', 1, level))) as prod_uid
                        from
                            dual
                        connect by
                            regexp_substr(p_prod_list, '[^:]+', 1, level) is not null
                    ) s
                where
                    not exists (
                        select
                            1
                        from
                            hwas_vertragsdetails d
                        where
                                d.vert_uid_fk = p_vert_uid
                            and d.prod_uid_fk = s.prod_uid
                    );

        end if;

    end sync_vertrag_produkte;

    procedure sync_asset_vertragsdetails (
        p_ass_uid in number,
        p_vd_list in varchar2,
        p_user    in varchar2
    ) is
    begin
    ------------------------------------------------------------------
    -- 1) Löschen: alle Vertragsdetail-Zuordnungen, die nicht mehr ausgewählt sind
    ------------------------------------------------------------------
        if p_vd_list is null then
            delete from hwas_asset_vertragsdetails
            where
                ass_uid_fk = p_ass_uid;

        else
            delete from hwas_asset_vertragsdetails d
            where
                    d.ass_uid_fk = p_ass_uid
                and not exists (
                    select
                        1
                    from
                        (
                            select distinct
                                to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                            from
                                dual
                            connect by
                                regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                        ) s
                    where
                        s.vd_uid = d.vd_uid_fk
                );

        end if;

    ------------------------------------------------------------------
    -- 2) Einfügen: alle neuen Vertragsdetails, die noch nicht zugeordnet sind
    ------------------------------------------------------------------
        if p_vd_list is not null then
            insert into hwas_asset_vertragsdetails (
                verass_uid,
                vd_uid_fk,
                ass_uid_fk,
                inserted,
                inserted_by
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as verass_uid,
                    s.vd_uid,
                    p_ass_uid,
                    sysdate,
                    p_user
                from
                    (
                        select distinct
                            to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                        from
                            dual
                        connect by
                            regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                    ) s
                where
                    not exists (
                        select
                            1
                        from
                            hwas_asset_vertragsdetails d
                        where
                                d.ass_uid_fk = p_ass_uid
                            and d.vd_uid_fk = s.vd_uid
                    );

        end if;

    end sync_asset_vertragsdetails;

    procedure delete_asset_relations (
        p_ass_uid in number
    ) is
    begin
        delete from hwas_asset_vertragsdetails
        where
            ass_uid_fk = p_ass_uid;

    end delete_asset_relations;

--Merge Produktlinie
    procedure merge_produktlinie (
        p_rec in hwas_produktlinie%rowtype
    ) is
        v_rec hwas_produktlinie%rowtype;
    begin
    -- Record lokal kopieren (IN-Parameter nicht änderbar)
        v_rec := p_rec;

    -- ID erzeugen, falls NULL
        if v_rec.prod_ln_uid is null then
            v_rec.prod_ln_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;

        merge into hwas_produktlinie tgt
        using (
            select
                v_rec.prod_ln_uid as prod_ln_uid,
                v_rec.name        as name,
                v_rec.bemerkung   as bemerkung
            from
                dual
        ) src on ( tgt.prod_ln_uid = src.prod_ln_uid )
        when matched then update
        set tgt.name = src.name,
            tgt.bemerkung = src.bemerkung
        when not matched then
        insert (
            prod_ln_uid,
            name,
            bemerkung )
        values
            ( src.prod_ln_uid,
              src.name,
              src.bemerkung );

    end merge_produktlinie;

    procedure delete_produktlinie (
        p_rec in hwas_produktlinie%rowtype
    ) is
    begin
        delete from hwas_produktlinie
        where
            prod_ln_uid = p_rec.prod_ln_uid;

    end delete_produktlinie;

 --Merge Vertrag Titel
    procedure merge_vertrag_titel (
        p_rec in hwas_vertrag_titel%rowtype
    ) is

        v_rec  hwas_vertrag_titel%rowtype;
        v_now  timestamp := systimestamp;
        v_user varchar2(255) := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            sys_context('USERENV', 'CLIENT_IDENTIFIER'),
            sys_context('USERENV', 'SESSION_USER')
        );
    begin
        v_rec := p_rec;

    -- ID erzeugen, falls NULL
        if v_rec.ver_ti_uid is null then
            v_rec.ver_ti_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;

        merge into hwas_vertrag_titel tgt
        using (
            select
                v_rec.ver_ti_uid  as ver_ti_uid,
                v_rec.name        as name,
                v_rec.vert_uid_fk as vert_uid_fk,
                v_now             as now_ts,
                v_user            as usr
            from
                dual
        ) src on ( tgt.ver_ti_uid = src.ver_ti_uid )
        when matched then update
        set tgt.name = src.name,
            tgt.vert_uid_fk = src.vert_uid_fk,
            tgt.updated = src.now_ts,
            tgt.updated_by = src.usr
        when not matched then
        insert (
            ver_ti_uid,
            name,
            vert_uid_fk,
            inserted,
            inserted_by,
            updated,
            updated_by )
        values
            ( src.ver_ti_uid,
              src.name,
              src.vert_uid_fk,
              src.now_ts,
              src.usr,
              src.now_ts,
              src.usr );

    end merge_vertrag_titel;

    procedure delete_vertrag_titel (
        p_rec in hwas_vertrag_titel%rowtype
    ) is
    begin
        delete from hwas_vertrag_titel
        where
            ver_ti_uid = p_rec.ver_ti_uid;

    end delete_vertrag_titel;
  
  --Merge Produktbestandteil
    procedure merge_produktbestandteil (
        p_rec in hwas_produktbestandteil%rowtype
    ) is

        v_rec  hwas_produktbestandteil%rowtype;
        v_now  date := sysdate;
        v_user varchar2(255) := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            sys_context('USERENV', 'CLIENT_IDENTIFIER'),
            sys_context('USERENV', 'SESSION_USER')
        );
    begin
        v_rec := p_rec;

    -- ID erzeugen, falls NULL
        if v_rec.prod_bes_uid is null then
      --v_rec.prod_bes_uid := TO_NUMBER(SYS_GUID(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
            v_rec.prod_bes_uid := to_number ( substr(
                rawtohex(sys_guid()),
                1,
                30
            ), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );

        end if;

        merge into hwas_produktbestandteil tgt
        using (
            select
                v_rec.prod_bes_uid         as prod_bes_uid,
                v_rec.name                 as name,
                v_rec.prod_uid_fk          as prod_uid_fk,
                v_rec.kommentar            as kommentar,
                v_now                      as now_ts,
                v_user                     as usr,
                v_rec.tech_ansprechpartner as tech_ansprechpartner
            from
                dual
        ) src on ( tgt.prod_bes_uid = src.prod_bes_uid )
        when matched then update
        set tgt.name = src.name,
            tgt.prod_uid_fk = src.prod_uid_fk,
            tgt.kommentar = src.kommentar,
            tgt.updated = src.now_ts,
            tgt.updated_by = src.usr,
            tgt.tech_ansprechpartner = src.tech_ansprechpartner
        when not matched then
        insert (
            prod_bes_uid,
            name,
            prod_uid_fk,
            kommentar,
            inserted,
            inserted_by,
            updated,
            updated_by,
            tech_ansprechpartner )
        values
            ( src.prod_bes_uid,
              src.name,
              src.prod_uid_fk,
              src.kommentar,
              src.now_ts,
              src.usr,
              src.now_ts,
              src.usr,
              src.tech_ansprechpartner );

    end merge_produktbestandteil;

    procedure delete_produktbestandteil (
        p_rec in hwas_produktbestandteil%rowtype
    ) is
    begin
        delete from hwas_produktbestandteil
        where
            prod_bes_uid = p_rec.prod_bes_uid;

    end delete_produktbestandteil;

--Merge Vertrag-Produkt

    procedure merge_vertrag_produkt (
        p_row  in out hwas_vertrag_produkt%rowtype,
        p_user in varchar2 default null
    ) is
        l_user varchar2(100);
        l_uid  hwas_vertrag_produkt.ver_prod_uid%type;
    begin
        l_user := nvl(p_user,
                      nvl(
                              sys_context('APEX$SESSION', 'APP_USER'),
                              user
                          ));

      -- UID erzeugen, wenn nicht gesetzt
        if p_row.ver_prod_uid is null then
            l_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        else
            l_uid := p_row.ver_prod_uid;
        end if;

        merge into hwas_vertrag_produkt tgt
        using (
            select
                l_uid             as ver_prod_uid,
                p_row.vert_uid_fk as vert_uid_fk,
                p_row.prod_uid_fk as prod_uid_fk,
                l_user            as usr
            from
                dual
        ) src on ( tgt.ver_prod_uid = src.ver_prod_uid )
        when matched then update
        set tgt.vert_uid_fk = src.vert_uid_fk,
            tgt.prod_uid_fk = src.prod_uid_fk,
            tgt.updated = sysdate,
            tgt.updated_by = src.usr
        when not matched then
        insert (
            ver_prod_uid,
            vert_uid_fk,
            prod_uid_fk,
            inserted,
            inserted_by,
            updated,
            updated_by )
        values
            ( src.ver_prod_uid,
              src.vert_uid_fk,
              src.prod_uid_fk,
              sysdate,
              src.usr,
              null,
              null );

      -- OUT: zurückgeben für APEX
        p_row.ver_prod_uid := l_uid;
--Delete
    end merge_vertrag_produkt;

    procedure delete_vertrag_produkt (
        p_ver_prod_uid in hwas_vertrag_produkt.ver_prod_uid%type
    ) is
    begin
        delete from hwas_vertrag_produkt
        where
            ver_prod_uid = p_ver_prod_uid;

    end delete_vertrag_produkt;
  
  
--Merge Vertragsdetails

    procedure merge_vertragsdetails (
        p_rec in hwas_vertragsdetails%rowtype
    ) is

        v_rec  hwas_vertragsdetails%rowtype;
        v_now  date := sysdate;
        v_user varchar2(255) := coalesce(
            sys_context('APEX$SESSION', 'APP_USER'),
            sys_context('USERENV', 'CLIENT_IDENTIFIER'),
            sys_context('USERENV', 'SESSION_USER')
        );
    begin
        v_rec := p_rec;

    -- ID erzeugen, falls NULL
        if v_rec.vd_uid is null then
            v_rec.vd_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;

        merge into hwas_vertragsdetails tgt
        using (
            select
                v_rec.vd_uid           as vd_uid,
                v_rec.prod_uid_fk      as prod_uid_fk,
                v_rec.vert_uid_fk      as vert_uid_fk,
                v_rec.ver_ti_uid_fk    as ver_ti_uid_fk,
                v_rec.prod_bes_uid_fk  as prod_bes_uid_fk,
                v_now                  as now_dt,
                v_user                 as usr,
                v_rec.bemerkung        as bemerkung,
                v_rec.betriebsrelevanz as betriebsrelevanz
            from
                dual
        ) src on ( tgt.vd_uid = src.vd_uid )
        when matched then update
        set tgt.prod_uid_fk = src.prod_uid_fk,
            tgt.vert_uid_fk = src.vert_uid_fk,
            tgt.ver_ti_uid_fk = src.ver_ti_uid_fk,
            tgt.prod_bes_uid_fk = src.prod_bes_uid_fk,
            tgt.updated = src.now_dt,
            tgt.updated_by = src.usr,
            tgt.bemerkung = src.bemerkung,
            tgt.betriebsrelevanz = src.betriebsrelevanz
        when not matched then
        insert (
            vd_uid,
            prod_uid_fk,
            vert_uid_fk,
            ver_ti_uid_fk,
            prod_bes_uid_fk,
            inserted,
            inserted_by,
            updated,
            updated_by,
            bemerkung,
            betriebsrelevanz )
        values
            ( src.vd_uid,
              src.prod_uid_fk,
              src.vert_uid_fk,
              src.ver_ti_uid_fk,
              src.prod_bes_uid_fk,
              src.now_dt,
              src.usr,
              src.now_dt,
              src.usr,
              src.bemerkung,
              src.betriebsrelevanz --09.03.2026 hinzugefügt
               );

    end merge_vertragsdetails;

    procedure delete_vertragsdetails (
        p_rec in hwas_vertragsdetails%rowtype
    ) is
    begin
        delete from hwas_vertragsdetails
        where
            vd_uid = p_rec.vd_uid;

    end delete_vertragsdetails;
  
  -- MERGE LEIFERANT ZU VERTRAGSDETAIL
    procedure merge_lieferant_vertragsdetail (
        p_rec     in hwas_lieferant_vertragsdetail%rowtype,
        p_vd_list in varchar2
    ) is
        l_user varchar2(100);
    begin
        l_user := nvl(p_rec.inserted_by, p_rec.updated_by);
        if p_rec.lie_uid_fk is null then
            raise_application_error(-20001, 'LIE_UID_FK muss befüllt sein.');
        end if;
        if l_user is null then
            raise_application_error(-20002, 'INSERTED_BY (oder UPDATED_BY) muss befüllt sein.');
        end if;

  ------------------------------------------------------------------
  -- 1) Löschen: alle VD-Zuordnungen, die nicht mehr ausgewählt sind
  ------------------------------------------------------------------
        if p_vd_list is null then
            delete from hwas_lieferant_vertragsdetail
            where
                lie_uid_fk = p_rec.lie_uid_fk;

        else
            delete from hwas_lieferant_vertragsdetail d
            where
                    d.lie_uid_fk = p_rec.lie_uid_fk
                and not exists (
                    select
                        1
                    from
                        (
                            select distinct
                                to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                            from
                                dual
                            connect by
                                regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                        ) s
                    where
                        s.vd_uid = d.vd_uid_fk
                );

        end if;

  ------------------------------------------------------------------
  -- 2) Einfügen: alle neuen VDs, die noch nicht zugeordnet sind
  ------------------------------------------------------------------
        if p_vd_list is not null then
            insert into hwas_lieferant_vertragsdetail (
                verlie_uid,
                vd_uid_fk,
                lie_uid_fk,
                inserted,
                inserted_by
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as verlie_uid,
                    s.vd_uid,
                    p_rec.lie_uid_fk,
                    nvl(p_rec.inserted, sysdate),
                    l_user
                from
                    (
                        select distinct
                            to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                        from
                            dual
                        connect by
                            regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                    ) s
                where
                    not exists (
                        select
                            1
                        from
                            hwas_lieferant_vertragsdetail d
                        where
                                d.lie_uid_fk = p_rec.lie_uid_fk
                            and d.vd_uid_fk = s.vd_uid
                    );

        end if;

    end merge_lieferant_vertragsdetail;

-- MERGE PROZESSE ZU VERTRAGSDETAILS

    procedure merge_prozess_vertragsdetail (
        p_rec     in hwas_prozesse_vertragsdetails%rowtype,
        p_vd_list in varchar2
    ) is
        l_user varchar2(100);
    begin
        l_user := nvl(p_rec.inserted_by, p_rec.updated_by);
        if p_rec.przp_uid_fk is null then
            raise_application_error(-20001, 'PRZP_UID_FK muss befüllt sein.');
        end if;
        if l_user is null then
            raise_application_error(-20002, 'INSERTED_BY oder UPDATED_BY muss befüllt sein.');
        end if;

  ------------------------------------------------------------------
  -- 1) Löschen: alle VD-Zuordnungen, die nicht mehr ausgewählt sind
  ------------------------------------------------------------------
        if p_vd_list is null then
            delete from hwas_prozesse_vertragsdetails
            where
                przp_uid_fk = p_rec.przp_uid_fk;

        else
            delete from hwas_prozesse_vertragsdetails d
            where
                    d.przp_uid_fk = p_rec.przp_uid_fk
                and not exists (
                    select
                        1
                    from
                        (
                            select distinct
                                to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                            from
                                dual
                            connect by
                                regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                        ) s
                    where
                        s.vd_uid = d.vd_uid_fk
                );

        end if;

  ------------------------------------------------------------------
  -- 2) Einfügen: alle neuen Vertragsdetails, die noch nicht zugeordnet sind
  ------------------------------------------------------------------
        if p_vd_list is not null then
            insert into hwas_prozesse_vertragsdetails (
                verprzp_uid,
                vd_uid_fk,
                przp_uid_fk,
                inserted,
                inserted_by
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as verprzp_uid,
                    s.vd_uid,
                    p_rec.przp_uid_fk,
                    nvl(p_rec.inserted, sysdate),
                    l_user
                from
                    (
                        select distinct
                            to_number(trim(regexp_substr(p_vd_list, '[^:]+', 1, level))) as vd_uid
                        from
                            dual
                        connect by
                            regexp_substr(p_vd_list, '[^:]+', 1, level) is not null
                    ) s
                where
                    not exists (
                        select
                            1
                        from
                            hwas_prozesse_vertragsdetails d
                        where
                                d.przp_uid_fk = p_rec.przp_uid_fk
                            and d.vd_uid_fk = s.vd_uid
                    );

        end if;

    end merge_prozess_vertragsdetail;

-- Merge Prozesse zu Anwendungen

    procedure merge_awh_eb3 (
        p_przp_uid_fk in number,
        p_asy_list    in varchar2,
        p_user        in varchar2 default null
    ) is
        l_user varchar2(255);
    begin
        l_user := nvl(p_user,
                      nvl(
                              v('APP_USER'),
                              user
                          ));
        if p_przp_uid_fk is null then
            raise_application_error(-20002, 'PRZP_UID_FK (Prozess) muss befüllt sein.');
        end if;

  ------------------------------------------------------------------
  -- 1) Löschen: alle SYSTEM-Zuordnungen, die nicht mehr ausgewählt sind
  ------------------------------------------------------------------
        if p_asy_list is null then
            delete from awh_main.awh_erhebungsbogen_3
            where
                przp_uid_fk = p_przp_uid_fk;

        else
            delete from awh_main.awh_erhebungsbogen_3 d
            where
                    d.przp_uid_fk = p_przp_uid_fk
                and not exists (
                    select
                        1
                    from
                        (
                            select distinct
                                to_number(trim(regexp_substr(p_asy_list, '[^:]+', 1, level))) as asy_lfd_nr
                            from
                                dual
                            connect by
                                regexp_substr(p_asy_list, '[^:]+', 1, level) is not null
                        ) s
                    where
                        s.asy_lfd_nr = d.asy_lfd_nr
                );

        end if;

  ------------------------------------------------------------------
  -- 2) Einfügen: alle neuen Systeme, die noch nicht vorhanden sind
  ------------------------------------------------------------------
        if p_asy_list is not null then
            insert into awh_main.awh_erhebungsbogen_3 (
                eb3_lfd_nr,
                asy_lfd_nr,
                eb3_timestamp,
                eb3_user,
                przp_uid_fk
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as eb3_lfd_nr,
                    s.asy_lfd_nr                                                    as asy_lfd_nr,
                    sysdate                                                         as eb3_timestamp,
                    l_user                                                          as eb3_user,
                    p_przp_uid_fk                                                   as przp_uid_fk
                from
                    (
                        select distinct
                            to_number(trim(regexp_substr(p_asy_list, '[^:]+', 1, level))) as asy_lfd_nr
                        from
                            dual
                        connect by
                            regexp_substr(p_asy_list, '[^:]+', 1, level) is not null
                    ) s
                where
                    not exists (
                        select
                            1
                        from
                            awh_main.awh_erhebungsbogen_3 d
                        where
                                d.przp_uid_fk = p_przp_uid_fk
                            and d.asy_lfd_nr = s.asy_lfd_nr
                    );

        end if;

    end merge_awh_eb3;

end pck_hwas_vertragsmanagement;
/


-- sqlcl_snapshot {"hash":"dc58bc752e9b797eac21770b26357f6fa4b280a3","type":"PACKAGE_BODY","name":"PCK_HWAS_VERTRAGSMANAGEMENT","schemaName":"AM_MAIN","sxml":""}