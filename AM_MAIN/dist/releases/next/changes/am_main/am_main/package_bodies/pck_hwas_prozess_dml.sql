-- liquibase formatted sql
-- changeset AM_MAIN:1774605607631 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_hwas_prozess_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwas_prozess_dml.sql:1f636187cf23cf4f5bd6ff2069e664154cb6ba0a:d63ab74b31e3977e300d6e3666efaf541023a13a:alter

create or replace package body am_main.pck_hwas_prozess_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

---------------------------------------------------------------------------------------------------

    -- MERGE PROCEDURE
    procedure p_merge_prozesstyp (
        p_prz_uid      in out nocopy hwas_prozesstyp.prz_uid%type,
        p_name         in hwas_prozesstyp.name%type,
        p_beschreibung in hwas_prozesstyp.beschreibung%type,
        p_user         in hwas_prozesstyp.inserted_by%type
    ) is
    begin
    -- Wenn PRZ_UID NULL ist, wird eine neue erzeugt
        if p_prz_uid is null then
            insert into hwas_prozesstyp (
                prz_uid,
                name,
                beschreibung,
                inserted,
                inserted_by
            ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                       p_name,
                       p_beschreibung,
                       sysdate,
                       p_user ) returning prz_uid into p_prz_uid; -- Neue ID an APEX zurückgeben
        else
            update hwas_prozesstyp
            set
                name = p_name,
                beschreibung = p_beschreibung,
                updated = sysdate,
                updated_by = p_user
            where
                prz_uid = p_prz_uid;

            if sql%rowcount = 0 then
                raise_application_error(-20001, 'Kein Datensatz mit dieser PRZ_UID gefunden.');
            end if;
        end if;

        commit;
    end p_merge_prozesstyp;

    procedure p_delete_prozesstyp (
        p_prz_uid in hwas_prozesstyp.prz_uid%type
    ) is
    begin
        delete from hwas_prozesstyp
        where
            prz_uid = p_prz_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Kein Datensatz mit dieser PRZ_UID gefunden.');
        end if;
        commit;
    end p_delete_prozesstyp;

    procedure p_merge_prozessstufe (
        p_przs_uid        in out nocopy hwas_prozessstufe.przs_uid%type,
        p_prz_uid         in hwas_prozessstufe.prz_uid%type,
        p_parent_przs_uid in hwas_prozessstufe.parent_przs_uid%type,
        p_name            in hwas_prozessstufe.name%type,
        p_beschreibung    in hwas_prozessstufe.beschreibung%type,
        p_user            in hwas_prozessstufe.inserted_by%type
    ) is
    begin
    -- Falls PRZS_UID NULL ist, wird eine neue ID generiert
        if p_przs_uid is null then
            insert into hwas_prozessstufe (
                przs_uid,
                prz_uid,
                parent_przs_uid,
                name,
                beschreibung,
                inserted,
                inserted_by
            ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                       p_prz_uid,
                       p_parent_przs_uid,
                       p_name,
                       p_beschreibung,
                       sysdate,
                       p_user ) returning przs_uid into p_przs_uid; -- Die neue UID zurückgeben
        else
            update hwas_prozessstufe
            set
                prz_uid = p_prz_uid,
                parent_przs_uid = p_parent_przs_uid,
                name = p_name,
                beschreibung = p_beschreibung,
                updated = sysdate,
                updated_by = p_user
            where
                przs_uid = p_przs_uid;

            if sql%rowcount = 0 then
                raise_application_error(-20001, 'Kein Datensatz mit dieser PRZS_UID gefunden.');
            end if;
        end if;

        commit;
    end p_merge_prozessstufe;

    procedure p_delete_prozessstufe (
        p_przs_uid in hwas_prozessstufe.przs_uid%type
    ) is
    begin
        delete from hwas_prozessstufe
        where
            przs_uid = p_przs_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Kein Datensatz mit dieser PRZS_UID gefunden.');
        end if;
        commit;
    end p_delete_prozessstufe;

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
    ) is
    begin
    -- Falls PRZP_UID NULL ist, wird eine neue ID generiert (INSERT)
        if p_przp_uid is null then
            insert into hwas_prozess (
                przp_uid,
                przs_uid,
                name,
                beschreibung,
                inserted,
                inserted_by,
                link_zum_fremdsystem,
                kritis_relevant,
                prozess_owner,
                gek_lfd_nr_fk,
                fbk_uid_fk
            ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                       p_przs_uid,
                       p_name,
                       p_beschreibung,
                       sysdate,
                       p_user,
                       p_link_zum_fremdsystem,
                       p_kriris_relevant,
                       p_prozess_owner,
                       p_gek_lfd_nr_fk,
                       p_fbk_uid_fk ) returning przp_uid into p_przp_uid; -- Die neue UID zurückgeben
        else
        -- Falls PRZP_UID existiert, Update der bestehenden Daten
            update hwas_prozess
            set
                przs_uid = p_przs_uid,
                name = p_name,
                beschreibung = p_beschreibung,
                updated = sysdate,
                updated_by = p_user,
                link_zum_fremdsystem = p_link_zum_fremdsystem,
                kritis_relevant = p_kriris_relevant,
                prozess_owner = p_prozess_owner,
                gek_lfd_nr_fk = p_gek_lfd_nr_fk,
                fbk_uid_fk = p_fbk_uid_fk
            where
                przp_uid = p_przp_uid;

            if sql%rowcount = 0 then
                raise_application_error(-20001, 'Kein Datensatz mit dieser PRZP_UID gefunden.');
            end if;
        end if;

        commit;
    end p_merge_prozess;

    procedure p_delete_prozess (
        p_przp_uid in hwas_prozess.przp_uid%type
    ) is
    begin
        delete from hwas_prozess
        where
            przp_uid = p_przp_uid;

        if sql%rowcount = 0 then
            raise_application_error(-20002, 'Kein Datensatz mit dieser PRZP_UID gefunden.');
        end if;
        commit;
    end p_delete_prozess;

--Merge Prozess System/Anwendung

    procedure merge_prozess_system (
        p_rec      in hwas_prozess_system%rowtype,
        p_asy_list in varchar2
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
  -- 1) Löschen: alle System-Zuordnungen, die nicht mehr ausgewählt sind
  ------------------------------------------------------------------
        if p_asy_list is null then
            delete from hwas_prozess_system
            where
                przp_uid_fk = p_rec.przp_uid_fk;

        else
            delete from hwas_prozess_system d
            where
                    d.przp_uid_fk = p_rec.przp_uid_fk
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
                        s.asy_lfd_nr = d.asy_lfd_nr_fk
                );

        end if;

  ------------------------------------------------------------------
  -- 2) Einfügen: alle neuen Systeme, die noch nicht zugeordnet sind
  ------------------------------------------------------------------
        if p_asy_list is not null then
            insert into hwas_prozess_system (
                przp_asy_uid,
                przp_uid_fk,
                asy_lfd_nr_fk,
                inserted,
                inserted_by
            )
                select
                    to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as przp_asy_uid,
                    p_rec.przp_uid_fk,
                    s.asy_lfd_nr,
                    nvl(p_rec.inserted, sysdate),
                    l_user
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
                            hwas_prozess_system d
                        where
                                d.przp_uid_fk = p_rec.przp_uid_fk
                            and d.asy_lfd_nr_fk = s.asy_lfd_nr
                    );

        end if;

    end merge_prozess_system;

--MERGE Prozess/BSI Bausteine
    procedure merge_bsi_bausteine (
        p_przp_uid     in number,
        p_bsi_uid_list in varchar2,
        p_user         in varchar2 default nvl(
            v('APP_USER'),
            user
        )
    ) as
    begin
        if p_przp_uid is null then
            raise_application_error(-20001, 'P_PRZP_UID darf nicht NULL sein.');
        end if;

    /*
      1. Lösche Zuordnungen, die für den Prozess existieren,
         aber nicht mehr im Shuttle enthalten sind.
    */
        delete from hwas_prozesse_bsi_bausteine t
        where
                t.przp_uid_fk = p_przp_uid
            and not exists (
                select
                    1
                from
                    (
                        select distinct
                            to_number(column_value) as bsi_uid
                        from
                            table ( apex_string.split(
                                nvl(p_bsi_uid_list, ''),
                                ':'
                            ) )
                        where
                            column_value is not null
                    ) s
                where
                    s.bsi_uid = t.bsi_uid_fk
            );

    /*
      2. Füge neue Zuordnungen ein, die im Shuttle stehen,
         aber noch nicht existieren.
    */
        insert into hwas_prozesse_bsi_bausteine (
            przpbsi_uid,
            bsi_uid_fk,
            przp_uid_fk,
            inserted_date,
            inserted_by,
            updated_date,
            updated_by
        )
            select
                to_number(substr(
                    rawtohex(sys_guid()),
                    1,
                    30
                ),
                          'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') as przpbsi_uid,
                s.bsi_uid,
                p_przp_uid,
                sysdate,
                p_user,
                null,
                null
            from
                (
                    select distinct
                        to_number(column_value) as bsi_uid
                    from
                        table ( apex_string.split(
                            nvl(p_bsi_uid_list, ''),
                            ':'
                        ) )
                    where
                        column_value is not null
                ) s
            where
                not exists (
                    select
                        1
                    from
                        hwas_prozesse_bsi_bausteine t
                    where
                            t.przp_uid_fk = p_przp_uid
                        and t.bsi_uid_fk = s.bsi_uid
                );

    exception
        when value_error then
            raise_application_error(-20002, 'Ungültiger Wert in P_BSI_UID_LIST. Die Liste darf nur numerische BSI_UID-Werte enthalten.'
            );
        when others then
            raise;
    end merge_bsi_bausteine;

end pck_hwas_prozess_dml;
/

