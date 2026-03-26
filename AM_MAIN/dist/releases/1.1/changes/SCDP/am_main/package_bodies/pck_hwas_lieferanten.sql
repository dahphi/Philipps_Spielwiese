-- liquibase formatted sql
-- changeset AM_MAIN:1774557218684 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwas_lieferanten.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_lieferanten.sql:null:a8c073b8b5936a2d386aaa45a092f06756cebd55:create

create or replace package body am_main.pck_hwas_lieferanten is

    procedure merge_dienstleister (
        p_rec in out hwas_dienstleister%rowtype
    ) is
    begin
  
    -- Neue GUID generieren, falls noch keine UID gesetzt ist
        if p_rec.dtl_uid is null then
            p_rec.dtl_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;
  
  -- MERGE auf HWAS_DIENSTLEISTER
        merge into hwas_dienstleister d
        using (
            select
                p_rec.dtl_uid as dtl_uid
            from
                dual
        ) src on ( d.dtl_uid = src.dtl_uid )
        when matched then update
        set d.name = p_rec.name,
            d.kreditoren_nr = p_rec.kreditoren_nr,
            d.link_kooperationsfreigabe = p_rec.link_kooperationsfreigabe,
            d.updated = sysdate,
            d.updated_by = nvl(
            v('APP_USER'),
            user
        )
        when not matched then
        insert (
            dtl_uid,
            name,
            kreditoren_nr,
            inserted,
            inserted_by )
        values
            ( p_rec.dtl_uid,
              p_rec.name,
              p_rec.kreditoren_nr,
              sysdate,
              nvl(
                  v('APP_USER'),
                  user
              ) );

    end merge_dienstleister;

--NOCHMAL ANGUCKEN UND TESTEN
    procedure delete_dienstleister (
        p_dtl_uid in number
    ) is
    begin
        delete from hwas_dienstleister
        where
            dtl_uid = p_dtl_uid;

    end delete_dienstleister;

    procedure merge_beauftragungen (
        p_rec              in out hwas_beauftragungen%rowtype,
        p_funktionsklassen in apex_application_global.vc_arr2
    ) is
    begin
  
    -- Neue GUID generieren, falls noch keine UID gesetzt ist
        if p_rec.bean_uid is null then
            p_rec.bean_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;
  
  -- MERGE auf HWAS_BEAUFTRAGUNGEN
        merge into hwas_beauftragungen b
        using (
            select
                p_rec.bean_uid as bean_uid
            from
                dual
        ) src on ( b.bean_uid = src.bean_uid )
        when matched then update
        set b.bestellnr = p_rec.bestellnr,
            b.beschreibung = p_rec.beschreibung,
            b.kostenstelle = p_rec.kostenstelle,
            b.anforderer = p_rec.anforderer,
            b.ab_lieferdatum = p_rec.ab_lieferdatum,
            b.bis_lieferdatum = p_rec.bis_lieferdatum,
            b.updated = sysdate,
            b.updated_by = nvl(
            v('APP_USER'),
            user
        ),
            b.dtl_uid_fk = p_rec.dtl_uid_fk
        when not matched then
        insert (
            bean_uid,
            bestellnr,
            beschreibung,
            kostenstelle,
            anforderer,
            ab_lieferdatum,
            bis_lieferdatum,
            inserted,
            inserted_by,
            dtl_uid_fk )
        values
            ( p_rec.bean_uid,
              p_rec.bestellnr,
              p_rec.beschreibung,
              p_rec.kostenstelle,
              p_rec.anforderer,
              p_rec.ab_lieferdatum,
              p_rec.bis_lieferdatum,
              sysdate,
              nvl(
                  v('APP_USER'),
                  user
              ),
              p_rec.dtl_uid_fk );
    
      -- Vorherige Funktionsklassen-Zuordnungen entfernen
        delete from hwas_bean_funktionsklassen
        where
            bean_uid_fk = p_rec.bean_uid;

  -- Neue Funktionsklassen-Zuordnungen einfügen
        for i in 1..p_funktionsklassen.count loop
            insert into hwas_bean_funktionsklassen (
                bean_uid_fk,
                fkl_uid_fk,
                inserted_by,
                inserted
            ) values ( p_rec.bean_uid,
                       to_number(p_funktionsklassen(i)),
                       nvl(
                           v('APP_USER'),
                           user
                       ),
                       sysdate );

        end loop;

    end merge_beauftragungen;

    procedure delete_beauftragungen (
        p_bean_uid in number
    ) is
    begin
        delete from hwas_beauftragungen
        where
            bean_uid = p_bean_uid;

    end delete_beauftragungen;

    procedure merge_lieferanten (
        p_rec in out sap_lieferanten%rowtype
    ) is
    begin
  
    -- Neue GUID generieren, falls noch keine UID gesetzt ist
        if p_rec.lie_uid is null then
            p_rec.lie_uid := to_number ( sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' );
        end if;
  
  -- MERGE auf HWAS_DIENSTLEISTER
        merge into sap_lieferanten l
        using (
            select
                p_rec.lie_uid as lie_uid
            from
                dual
        ) src on ( l.lie_uid = src.lie_uid )
        when matched then update
        set l.bezeichnung = p_rec.bezeichnung,
            l.kreditoren_nr = p_rec.kreditoren_nr,
            l.link_kooperationsfreigabe = p_rec.link_kooperationsfreigabe,
            l.updated = sysdate,
            l.updated_by = nvl(
            v('APP_USER'),
            user
        ),
            l.bemerkung = p_rec.bemerkung
        when not matched then
        insert (
            lie_uid,
            bezeichnung,
            kreditoren_nr,
            inserted,
            inserted_by,
            bemerkung )
        values
            ( p_rec.lie_uid,
              p_rec.bezeichnung,
              p_rec.kreditoren_nr,
              sysdate,
              nvl(
                  v('APP_USER'),
                  user
              ),
              p_rec.bemerkung );

    end merge_lieferanten;

end pck_hwas_lieferanten;
/

