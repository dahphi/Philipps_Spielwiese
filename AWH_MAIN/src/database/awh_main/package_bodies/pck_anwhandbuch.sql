create or replace package body awh_main.pck_anwhandbuch as

  -------------------------------------------------------------------------------------------------------------------------------
  --
  -- Basistabellen
  --
  -------------------------------------------------------------------------------------------------------------------------------

  /**PROCEDURE PRC_FILL_TAB_PERSON_SHORT AS
  BEGIN
    FOR chars IN
      (
        SELECT CHR(LEVEL+96) AS PART_A FROM DUAL CONNECT BY LEVEL <27
      )
      LOOP
        FOR aduser IN
        (
          SELECT val
          FROM table(apex_ldap.search (
                   p_host            => 'ad.netcologne.intern',
                   p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                   p_pass            => 'ZMORj3Pw',
                   p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                   p_search_filter   => '&(|(useraccountcontrol=512)(useraccountcontrol=66048))(sAMAccountName=' || chars.PART_A || '*)',
                   p_attribute_names => 'sAMAccountName' ))
        )
        LOOP
            MERGE INTO AWH_TAB_PERSON dest
            USING
            (
                SELECT
                    aduser.val AS PER_AD_SHORT
                FROM DUAL
              WHERE
                UPPER(aduser.val) NOT IN (
                    'BILDERSTOECKCHEN', 'BOCKLEMUEND', 'DEUTZ', 'EHRENFELD', 'EIGELSTEIN', 'LINDENTHAL', 'LOEVENICH', 'LONGERICH', 'MARIENBURG',
                    'NIEHL', 'NIPPES', 'PESCH', 'PORZ', 'SHOWROOMGK', 'SUELZ', 'ZOLLSTOCK', 'PMFON', 'INNENDIENST KÃLN'
                    )
                AND UPPER(aduser.val) NOT LIKE ('IDM%')
                AND UPPER(aduser.val) NOT LIKE ('TECBCP%')
                AND UPPER(aduser.val) NOT LIKE ('NMC%')
                AND UPPER(aduser.val) NOT LIKE ('TEACH%')
                AND UPPER(aduser.val) NOT LIKE ('TK%')
            ) src
            ON (upper(src.PER_AD_SHORT) = upper(dest.PER_AD_SHORT))
            WHEN NOT MATCHED THEN
                INSERT (PER_AD_SHORT)
                VALUES (UPPER(src.PER_AD_SHORT));
        END LOOP;
      END LOOP;
  END PRC_FILL_TAB_PERSON_SHORT;

  PROCEDURE PRC_UPDATE_TAB_PERSON AS
  BEGIN
      FOR adshort IN
      (
        SELECT per_ad_short
        FROM AWH_TAB_PERSON
      )
      LOOP
        FOR outData IN
        (
            SELECT *
            FROM TABLE(FKT_PERSON_BY_AD(adshort.PER_AD_SHORT))
        )
        LOOP
            UPDATE AWH_TAB_PERSON
            SET
                per_name =outData.NAME,
                per_abteilung =outData.ABTEILUNG,
                per_email =outData.EMAIL,
                per_telefon =outData.TELEFON,
                per_bereich =outData.BEREICH,
                per_gruppe =outData.GRUPPE,
                per_buero =outData.BUERO
            WHERE
                per_ad_short = adshort.PER_AD_SHORT;
        END LOOP;
      END LOOP;
  END PRC_UPDATE_TAB_PERSON;

  FUNCTION FKT_PERSON_BY_AD(PI_VC_ADSHORT VARCHAR2) RETURN tpPerson PIPELINED AS
    vc_bereich    VARCHAR2(100);
    vc_abteilung  VARCHAR2(100);
    vc_gruppe     VARCHAR2(100);
    outData       tPersonRecord;
  BEGIN
    -- Bereich, Abteilung, Gruppe
    WITH DATEN AS
    (
        SELECT
        NAME,
        VAL,
        --fixing vermischte OUs: Erst wird in OU Eins, OU Zwei und so weiter sortiert.
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 6), 'OU=') AS SECHS,
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 5), 'OU=') AS FUNF,
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 4), 'OU=') AS VIER,
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 3), 'OU=') AS DREI,
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 2), 'OU=') AS ZWEI,
        REPLACE(regexp_substr(DN, 'OU=+.[^,]*', 1, 1), 'OU=') AS EINS
        FROM table(apex_ldap.search (
                   p_host            => 'ad.netcologne.intern',
                 p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                 p_pass            => 'ZMORj3Pw',
                   p_search_base     => 'DC=netcologne,DC=intern',
                   p_search_filter   => 'sAMAccountName='||apex_escape.ldap_search_filter(PI_VC_ADSHORT),
                   p_attribute_names => 'sAMAccountName' )
            )
        )
    Select
    --fixing vermischte OUs: Dann wird geschaut wo 'Abteilungen' steht und von dort aus gehend ist der nÃ¤chste Punkt der Bereich, die Abteilung und dann die Gruppe.
    CASE
        WHEN SECHS = 'Abteilungen' THEN SUBSTR(FUNF, 1, 1000)
        WHEN FUNF = 'Abteilungen' THEN SUBSTR(VIER, 1, 1000)
        WHEN VIER = 'Abteilungen' THEN SUBSTR(DREI, 1, 1000)
        WHEN DREI = 'Abteilungen' THEN SUBSTR(ZWEI, 1, 1000)
        WHEN ZWEI = 'Abteilungen' THEN SUBSTR(EINS, 1, 1000)
        ELSE 'ohne Bereich'
    END AS BEREICH,
    CASE
        WHEN SECHS = 'Abteilungen' THEN SUBSTR(VIER, 1, 1000)
        WHEN FUNF = 'Abteilungen' THEN SUBSTR(DREI, 1, 1000)
        WHEN VIER = 'Abteilungen' THEN SUBSTR(ZWEI, 1, 1000)
        WHEN DREI = 'Abteilungen' THEN SUBSTR(EINS, 1, 1000)
        ELSE 'ohne Abteilung'
    END AS ABTEILUNG,
    CASE
        WHEN SECHS = 'Abteilungen' THEN SUBSTR(DREI, 1, 1000)
        WHEN FUNF = 'Abteilungen' THEN SUBSTR(ZWEI, 1, 1000)
        WHEN VIER = 'Abteilungen' THEN SUBSTR(EINS, 1, 1000)
        ELSE 'ohne Gruppe'
    END AS GRUPPE
    INTO vc_bereich,vc_abteilung,vc_gruppe
    FROM DATEN;

    outData.ADSHORT := PI_VC_ADSHORT;
    outData.BEREICH := vc_bereich;
    outData.ABTEILUNG := vc_abteilung;
    outData.GRUPPE := vc_gruppe;

    SELECT SUBSTR(MAX(VAL),1,1000) INTO outData.NAME
    FROM table(apex_ldap.search (
                                   p_host            => 'ad.netcologne.intern',
                                   p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                   p_pass            => 'ZMORj3Pw',
                                   p_search_base     => 'DC=netcologne,DC=intern',
                                   p_search_filter   => 'sAMAccountName='||apex_escape.ldap_search_filter(PI_VC_ADSHORT),
                                   p_attribute_names => 'displayname' )
                            );

    SELECT SUBSTR(MAX(VAL),1,255) INTO outData.EMAIL
    FROM table(apex_ldap.search (
                                   p_host            => 'ad.netcologne.intern',
                                   p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                   p_pass            => 'ZMORj3Pw',
                                   p_search_base     => 'DC=netcologne,DC=intern',
                                   p_search_filter   => 'sAMAccountName='||apex_escape.ldap_search_filter(PI_VC_ADSHORT),
                                   p_attribute_names => 'mail' )
                                );
    SELECT SUBSTR(MAX(VAL),1,100) INTO outData.TELEFON
    FROM table(apex_ldap.search (
                                   p_host            => 'ad.netcologne.intern',
                                   p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                   p_pass            => 'ZMORj3Pw',
                                   p_search_base     => 'DC=netcologne,DC=intern',
                                   p_search_filter   => 'sAMAccountName='||apex_escape.ldap_search_filter(PI_VC_ADSHORT),
                                   p_attribute_names => 'telephonenumber' )
                                );

    SELECT SUBSTR(MAX(VAL),1,1000) INTO outData.BUERO
    FROM table(apex_ldap.search (
               p_host            => 'ad.netcologne.intern',
               p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
               p_pass            => 'ZMORj3Pw',
               p_search_base     => 'DC=netcologne,DC=intern',
               p_search_filter   => 'sAMAccountName='||apex_escape.ldap_search_filter(PI_VC_ADSHORT),
               p_attribute_names => 'physicalDeliveryOfficeName' )
        );

    PIPE ROW (outData);
    RETURN;
  END FKT_PERSON_BY_AD;*/

  -------------------------------------------------------------------------------------------------------------------------------
  --
  -- Systeme
  --
  -------------------------------------------------------------------------------------------------------------------------------

    procedure prc_update_system_aktiv_eingef (
        pi_n_asy_lfd_nr   number,
        pi_dt_eingefuehrt date
    ) as
    begin
        update awh_system
        set
            asy_einfuehrung = pi_dt_eingefuehrt
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

    end prc_update_system_aktiv_eingef;

    function fkt_get_erhebungsbogen (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen
        pipelined
    as
        outdata terhebungsbogenrecord;
    begin
        select
            asy_lfd_nr,
            erh_lfd_nr,
            per_lfd_nr_ausf_per,
            erh_datum
        into
            outdata.asy_lfd_nr,
            outdata.erh_lfd_nr,
            outdata.ausf_person,
            outdata.erh_datum
        from
            awh_erhebungsbogen
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen;

    procedure prc_set_erhebungsbogen (
        pi_n_asy_lfd_nr   number,
        pi_n_erh_lfd_nr   number,
        pi_vc_ausf_person varchar2,
        pi_dt_erh_datum   date,
        pi_vc_erh_user    varchar2
    ) as
    begin
        merge into awh_erhebungsbogen dest
        using (
            select
                pi_n_asy_lfd_nr   as asy_lfd_nr,
                pi_n_erh_lfd_nr   as erh_lfd_nr,
                pi_vc_ausf_person as per_lfd_nr_ausf_per,
                pi_dt_erh_datum   as erh_datum,
                pi_vc_erh_user    as erh_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.per_lfd_nr_ausf_per = src.per_lfd_nr_ausf_per,
            dest.erh_datum = trunc(src.erh_datum),
            dest.erh_user = src.erh_user
        when not matched then
        insert (
            asy_lfd_nr,
            per_lfd_nr_ausf_per,
            erh_datum,
            erh_user )
        values
            ( src.asy_lfd_nr,
              src.per_lfd_nr_ausf_per,
              trunc(src.erh_datum),
              src.erh_user );

    end prc_set_erhebungsbogen;

    function fkt_get_erhebungsbogen_1 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen1
        pipelined
    as
        outdata terhebungsbogen1record;
    begin
        select
            asy_lfd_nr,
            eb1_lfd_nr,
            eb1_inakt_persdata,
            eb1_verarb_persdata,
            eb1_name_anschrift,
            link_zum_anhang,
            eb1_loeschkonzept
        into
            outdata.asy_lfd_nr,
            outdata.eb1_lfd_nr,
            outdata.eb1_inakt_persdata,
            outdata.eb1_verarb_persdata,
            outdata.eb1_name_anschrift,
            outdata.link_zum_anhang,
            outdata.eb1_loeschkonzept
        from
            awh_erhebungsbogen_1
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_1;

    procedure prc_set_erhebungsbogen_1 (
        pi_n_asy_lfd_nr          number,
        pi_n_eb1_lfd_nr          number,
        pi_n_eb1_inakt_persdata  number,
        pi_n_eb1_verarb_persdata number,
        pi_vc_eb1_name_anschrift varchar2,
        pi_vc_link_zum_anhang    varchar2,
        pi_n_eb1_loeschkonzept   number,
        pi_vc_eb1_user           varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_1 dest
        using (
            select
                pi_n_asy_lfd_nr          as asy_lfd_nr,
                pi_n_eb1_lfd_nr          as eb1_lfd_nr,
                pi_n_eb1_inakt_persdata  as eb1_inakt_persdata,
                pi_n_eb1_verarb_persdata as eb1_verarb_persdata,
                pi_vc_eb1_name_anschrift as eb1_name_anschrift,
                pi_vc_link_zum_anhang    as link_zum_anhang,
                pi_n_eb1_loeschkonzept   as eb1_loeschkonzept,
                pi_vc_eb1_user           as eb1_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb1_verarb_persdata = src.eb1_verarb_persdata,
            dest.eb1_inakt_persdata = src.eb1_inakt_persdata,
            dest.eb1_name_anschrift = src.eb1_name_anschrift,
            dest.link_zum_anhang = src.link_zum_anhang,
            dest.eb1_loeschkonzept = src.eb1_loeschkonzept,
            dest.eb1_user = src.eb1_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb1_inakt_persdata,
            eb1_verarb_persdata,
            eb1_name_anschrift,
            link_zum_anhang,
            eb1_loeschkonzept,
            eb1_user )
        values
            ( src.asy_lfd_nr,
              src.eb1_inakt_persdata,
              src.eb1_verarb_persdata,
              src.eb1_name_anschrift,
              src.link_zum_anhang,
              src.eb1_loeschkonzept,
              src.eb1_user );

    end prc_set_erhebungsbogen_1;

    function fkt_get_erhebungsbogen_2 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen2
        pipelined
    as
        outdata terhebungsbogen2record;
    begin
        select
            eb2_lfd_nr,
            asy_lfd_nr,
            eb2_zweck_persdaten,
            eb2_spezialgesetz_regel,
            eb2_einwilligung,
            eb2_kollektivvereinbarung,
            eb2_beschaeftigung,
            eb2_vertragsanbahnung,
            eb2_interessenabwaegung
        into
            outdata.eb2_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb2_zweck_persdaten,
            outdata.eb2_spezialgesetz_regel,
            outdata.eb2_einwilligung,
            outdata.eb2_kollektivvereinbarung,
            outdata.eb2_beschaeftigung,
            outdata.eb2_vertragsanbahnung,
            outdata.eb2_interessenabwaegung
        from
            awh_erhebungsbogen_2
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_2;

    procedure prc_set_erhebungsbogen_2 (
        pi_n_asy_lfd_nr               number,
        pi_n_eb2_lfd_nr               number,
        pi_vc_eb2_zweck_persdaten     varchar2,
        pi_vc_eb2_spezialgesetz_regel varchar2,
        pi_vc_eb2_einwilligung        varchar2,
        pi_vc_eb2_kollektivverei      varchar2,
        pi_vc_eb2_beschaeftigung      varchar2,
        pi_vc_eb2_vertragsanbahnung   varchar2,
        pi_vc_eb2_interessenabwaegung varchar2,
        pi_vc_eb2_user                varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_2 dest
        using (
            select
                pi_n_asy_lfd_nr               as asy_lfd_nr,
                pi_n_eb2_lfd_nr               as eb2_lfd_nr,
                pi_vc_eb2_zweck_persdaten     as eb2_zweck_persdaten,
                pi_vc_eb2_spezialgesetz_regel as eb2_spezialgesetz_regel,
                pi_vc_eb2_einwilligung        as eb2_einwilligung,
                pi_vc_eb2_kollektivverei      as eb2_kollektivvereinbarung,
                pi_vc_eb2_beschaeftigung      as eb2_beschaeftigung,
                pi_vc_eb2_vertragsanbahnung   as eb2_vertragsanbahnung,
                pi_vc_eb2_interessenabwaegung as eb2_interessenabwaegung,
                pi_vc_eb2_user                as eb2_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb2_zweck_persdaten = src.eb2_zweck_persdaten,
            dest.eb2_spezialgesetz_regel = src.eb2_spezialgesetz_regel,
            dest.eb2_einwilligung = src.eb2_einwilligung,
            dest.eb2_kollektivvereinbarung = src.eb2_kollektivvereinbarung,
            dest.eb2_beschaeftigung = src.eb2_beschaeftigung,
            dest.eb2_vertragsanbahnung = src.eb2_vertragsanbahnung,
            dest.eb2_interessenabwaegung = src.eb2_interessenabwaegung,
            dest.eb2_user = src.eb2_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb2_zweck_persdaten,
            eb2_spezialgesetz_regel,
            eb2_einwilligung,
            eb2_kollektivvereinbarung,
            eb2_beschaeftigung,
            eb2_vertragsanbahnung,
            eb2_interessenabwaegung,
            eb2_user )
        values
            ( src.asy_lfd_nr,
              src.eb2_zweck_persdaten,
              src.eb2_spezialgesetz_regel,
              src.eb2_einwilligung,
              src.eb2_kollektivvereinbarung,
              src.eb2_beschaeftigung,
              src.eb2_vertragsanbahnung,
              src.eb2_interessenabwaegung,
              src.eb2_user );

    end prc_set_erhebungsbogen_2;

    function fkt_get_erhebungsbogen_5 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen5
        pipelined
    as
        outdata terhebungsbogen5record;
    begin
        select
            eb5_lfd_nr,
            asy_lfd_nr,
            eb5_internestelle_dwi,
            eb5_artdaten_dwi,
            eb5_zweck_dwi,
            eb5_externestelle_dwe,
            eb5_artdaten_dwe,
            eb5_zweck_dwe,
            eb5_staat_dws,
            eb5_artdaten_dws,
            eb5_zweck_dws,
            eb5_user
        into
            outdata.eb5_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb5_internestelle_dwi,
            outdata.eb5_artdaten_dwi,
            outdata.eb5_zweck_dwi,
            outdata.eb5_externestelle_dwe,
            outdata.eb5_artdaten_dwe,
            outdata.eb5_zweck_dwe,
            outdata.eb5_staat_dws,
            outdata.eb5_artdaten_dws,
            outdata.eb5_zweck_dws,
            outdata.eb5_user
        from
            awh_erhebungsbogen_5
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_5;

    procedure prc_set_erhebungsbogen_5 (
        pi_n_asy_lfd_nr             number,
        pi_n_eb5_lfd_nr             number,
        pi_vc_eb5_internestelle_dwi varchar2,
        pi_vc_eb5_artdaten_dwi      varchar2,
        pi_vc_eb5_zweck_dwi         varchar2,
        pi_vc_eb5_externestelle_dwe varchar2,
        pi_vc_eb5_artdaten_dwe      varchar2,
        pi_vc_eb5_zweck_dwe         varchar2,
        pi_vc_eb5_staat_dws         varchar2,
        pi_vc_eb5_artdaten_dws      varchar2,
        pi_vc_eb5_zweck_dws         varchar2,
        pi_vc_eb5_user              varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_5 dest
        using (
            select
                pi_n_asy_lfd_nr             as asy_lfd_nr,
                pi_n_eb5_lfd_nr             as eb5_lfd_nr,
                pi_vc_eb5_internestelle_dwi as eb5_internestelle_dwi,
                pi_vc_eb5_artdaten_dwi      as eb5_artdaten_dwi,
                pi_vc_eb5_zweck_dwi         as eb5_zweck_dwi,
                pi_vc_eb5_externestelle_dwe as eb5_externestelle_dwe,
                pi_vc_eb5_artdaten_dwe      as eb5_artdaten_dwe,
                pi_vc_eb5_zweck_dwe         as eb5_zweck_dwe,
                pi_vc_eb5_staat_dws         as eb5_staat_dws,
                pi_vc_eb5_artdaten_dws      as eb5_artdaten_dws,
                pi_vc_eb5_zweck_dws         as eb5_zweck_dws,
                pi_vc_eb5_user              as eb5_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb5_internestelle_dwi = src.eb5_internestelle_dwi,
            dest.eb5_artdaten_dwi = src.eb5_artdaten_dwi,
            dest.eb5_zweck_dwi = src.eb5_zweck_dwi,
            dest.eb5_externestelle_dwe = src.eb5_externestelle_dwe,
            dest.eb5_artdaten_dwe = src.eb5_artdaten_dwe,
            dest.eb5_zweck_dwe = src.eb5_zweck_dwe,
            dest.eb5_staat_dws = src.eb5_staat_dws,
            dest.eb5_artdaten_dws = src.eb5_artdaten_dws,
            dest.eb5_zweck_dws = src.eb5_zweck_dws,
            dest.eb5_user = src.eb5_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb5_internestelle_dwi,
            eb5_artdaten_dwi,
            eb5_zweck_dwi,
            eb5_externestelle_dwe,
            eb5_artdaten_dwe,
            eb5_zweck_dwe,
            eb5_staat_dws,
            eb5_artdaten_dws,
            eb5_zweck_dws,
            eb5_user )
        values
            ( src.asy_lfd_nr,
              src.eb5_internestelle_dwi,
              src.eb5_artdaten_dwi,
              src.eb5_zweck_dwi,
              src.eb5_externestelle_dwe,
              src.eb5_artdaten_dwe,
              src.eb5_zweck_dwe,
              src.eb5_staat_dws,
              src.eb5_artdaten_dws,
              src.eb5_zweck_dws,
              src.eb5_user );

    end prc_set_erhebungsbogen_5;

    function fkt_get_erhebungsbogen_6 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen6
        pipelined
    as
        outdata terhebungsbogen6record;
    begin
        select
            eb6_lfd_nr,
            asy_lfd_nr,
            eb6_aufbewloeschfrist,
            eb6_loeschregeln,
            eb6_user
        into
            outdata.eb6_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb6_aufbewloeschfrist,
            outdata.eb6_loeschregeln,
            outdata.eb6_user
        from
            awh_erhebungsbogen_6
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_6;

    procedure prc_set_erhebungsbogen_6 (
        pi_n_asy_lfd_nr             number,
        pi_n_eb6_lfd_nr             number,
        pi_vc_eb6_aufbewloeschfrist varchar2,
        pi_vc_eb6_loeschregeln      varchar2,
        pi_vc_eb6_user              varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_6 dest
        using (
            select
                pi_n_asy_lfd_nr             as asy_lfd_nr,
                pi_n_eb6_lfd_nr             as eb6_lfd_nr,
                pi_vc_eb6_aufbewloeschfrist as eb6_aufbewloeschfrist,
                pi_vc_eb6_loeschregeln      as eb6_loeschregeln,
                pi_vc_eb6_user              as eb6_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb6_aufbewloeschfrist = src.eb6_aufbewloeschfrist,
            dest.eb6_loeschregeln = src.eb6_loeschregeln,
            dest.eb6_user = src.eb6_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb6_aufbewloeschfrist,
            eb6_loeschregeln,
            eb6_user )
        values
            ( src.asy_lfd_nr,
              src.eb6_aufbewloeschfrist,
              src.eb6_loeschregeln,
              src.eb6_user );

    end prc_set_erhebungsbogen_6;

    function fkt_get_erhebungsbogen_9 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen9
        pipelined
    as
        outdata terhebungsbogen9record;
    begin
        select
            eb9_lfd_nr,
            asy_lfd_nr,
            eb9_ds_itsicherheit_grund,
            eb9_risikoanalyse_erfolgt,
            eb9_massnahmen_sicherheitskonz,
            eb9_anonym_pseudonym,
            eb9_backup,
            eb9_redundantedaten,
            eb9_schutzderrechte,
            eb9_protokollierung,
            eb9_pruefung_abstaende,
            eb9_user
        into
            outdata.eb9_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb9_ds_itsicherheit_grund,
            outdata.eb9_risikoanalyse_erfolgt,
            outdata.eb9_massnahmen_sicherheitskonz,
            outdata.eb9_anonym_pseudonym,
            outdata.eb9_backup,
            outdata.eb9_redundantedaten,
            outdata.eb9_schutzderrechte,
            outdata.eb9_protokollierung,
            outdata.eb9_pruefung_abstaende,
            outdata.eb9_user
        from
            awh_erhebungsbogen_9
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_9;

    procedure prc_set_erhebungsbogen_9 (
        pi_n_asy_lfd_nr                number,
        pi_n_eb9_lfd_nr                number,
        pi_vc_eb9_ds_itsicherheit_grun varchar2,
        pi_vc_eb9_risikoanalyse_erfolg varchar2,
        pi_vc_eb9_massnahmen_sichkonz  varchar2,
        pi_vc_eb9_anonym_pseudonym     varchar2,
        pi_vc_eb9_backup               varchar2,
        pi_vc_eb9_redundantedaten      varchar2,
        pi_vc_eb9_schutzderrechte      varchar2,
        pi_vc_eb9_protokollierung      varchar2,
        pi_vc_eb9_pruefung_abstaende   varchar2,
        pi_vc_eb9_user                 varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_9 dest
        using (
            select
                pi_n_asy_lfd_nr                as asy_lfd_nr,
                pi_n_eb9_lfd_nr                as eb9_lfd_nr,
                pi_vc_eb9_ds_itsicherheit_grun as eb9_ds_itsicherheit_grund,
                pi_vc_eb9_risikoanalyse_erfolg as eb9_risikoanalyse_erfolgt,
                pi_vc_eb9_massnahmen_sichkonz  as eb9_massnahmen_sichkonz,
                pi_vc_eb9_anonym_pseudonym     as eb9_anonym_pseudonym,
                pi_vc_eb9_backup               as eb9_backup,
                pi_vc_eb9_redundantedaten      as eb9_redundantedaten,
                pi_vc_eb9_schutzderrechte      as eb9_schutzderrechte,
                pi_vc_eb9_protokollierung      as eb9_protokollierung,
                pi_vc_eb9_pruefung_abstaende   as eb9_pruefung_abstaende,
                pi_vc_eb9_user                 as eb9_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb9_ds_itsicherheit_grund = src.eb9_ds_itsicherheit_grund,
            dest.eb9_risikoanalyse_erfolgt = src.eb9_risikoanalyse_erfolgt,
            dest.eb9_massnahmen_sicherheitskonz = src.eb9_massnahmen_sichkonz,
            dest.eb9_anonym_pseudonym = src.eb9_anonym_pseudonym,
            dest.eb9_backup = nvl(src.eb9_backup, dest.eb9_backup),
            dest.eb9_redundantedaten = nvl(src.eb9_redundantedaten, dest.eb9_redundantedaten),
            dest.eb9_schutzderrechte = src.eb9_schutzderrechte,
            dest.eb9_protokollierung = nvl(src.eb9_protokollierung, dest.eb9_protokollierung),
            dest.eb9_pruefung_abstaende = src.eb9_pruefung_abstaende,
            dest.eb9_user = src.eb9_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb9_ds_itsicherheit_grund,
            eb9_risikoanalyse_erfolgt,
            eb9_massnahmen_sicherheitskonz,
            eb9_anonym_pseudonym,
            eb9_backup,
            eb9_redundantedaten,
            eb9_schutzderrechte,
            eb9_protokollierung,
            eb9_pruefung_abstaende,
            eb9_user )
        values
            ( src.asy_lfd_nr,
              src.eb9_ds_itsicherheit_grund,
              src.eb9_risikoanalyse_erfolgt,
              src.eb9_massnahmen_sichkonz,
              src.eb9_anonym_pseudonym,
              src.eb9_backup,
              src.eb9_redundantedaten,
              src.eb9_schutzderrechte,
              src.eb9_protokollierung,
              src.eb9_pruefung_abstaende,
              src.eb9_user );

    end prc_set_erhebungsbogen_9;

    procedure prc_set_erhebungsbogen_9_dfa (
        pi_n_asy_lfd_nr         number,
        pi_vc_e9d_link_schw_dfa varchar2,
        pi_vc_e9d_link_dfa      varchar2,
        pi_vc_e9d_schw          varchar2,
        pi_vc_e9d_user          varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_9_dfa dest
        using (
            select
                pi_n_asy_lfd_nr         as asy_lfd_nr,
                pi_vc_e9d_link_schw_dfa as e9d_link_schw_dfa,
                pi_vc_e9d_link_dfa      as e9d_link_dfa,
                pi_vc_e9d_schw          as e9d_schw,
                pi_vc_e9d_user          as e9d_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.e9d_link_schw_dfa = src.e9d_link_schw_dfa,
            dest.e9d_link_dfa = src.e9d_link_dfa,
            dest.e9d_schw = src.e9d_schw,
            dest.e9d_user = src.e9d_user
        when not matched then
        insert (
            asy_lfd_nr,
            e9d_link_schw_dfa,
            e9d_link_dfa,
            e9d_schw,
            e9d_user )
        values
            ( src.asy_lfd_nr,
              src.e9d_link_schw_dfa,
              src.e9d_link_dfa,
              src.e9d_schw,
              src.e9d_user );

    end prc_set_erhebungsbogen_9_dfa;

    function fkt_get_erhebungsbogen_11 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen11
        pipelined
    as
        outdata terhebungsbogen11record;
    begin
        select
            eb11_lfd_nr,
            asy_lfd_nr,
            eb11_satz_pers_daten,
            eb11_nakodv_form,
            eb11_nakodv_zeitpunkt,
            eb11_kodsb_form,
            eb11_kodsb_zeitpunkt,
            eb11_zweckrecht_form,
            eb11_zweckrecht_zeitpunkt,
            eb11_empfkat_form,
            eb11_empfkat_zeitpunkt,
            eb11_dauerpers_form,
            eb11_dauerpers_zeitpunkt,
            eb11_widerspruch_form,
            eb11_widerspruch_zeitpunkt,
            eb11_einrueck_form,
            eb11_einrueck_zeitpunkt,
            eb11_beschrecht_form,
            eb11_beschrecht_zeitpunkt,
            eb11_infobereit_form,
            eb11_infobereit_zeitpunkt,
            eb11_wwkomplsatz,
            eb11_user
        into
            outdata.eb11_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb11_satz_pers_daten,
            outdata.eb11_nakodv_form,
            outdata.eb11_nakodv_zeitpunkt,
            outdata.eb11_kodsb_form,
            outdata.eb11_kodsb_zeitpunkt,
            outdata.eb11_zweckrecht_form,
            outdata.eb11_zweckrecht_zeitpunkt,
            outdata.eb11_empfkat_form,
            outdata.eb11_empfkat_zeitpunkt,
            outdata.eb11_dauerpers_form,
            outdata.eb11_dauerpers_zeitpunkt,
            outdata.eb11_widerspruch_form,
            outdata.eb11_widerspruch_zeitpunkt,
            outdata.eb11_einrueck_form,
            outdata.eb11_einrueck_zeitpunkt,
            outdata.eb11_beschrecht_form,
            outdata.eb11_beschrecht_zeitpunkt,
            outdata.eb11_infobereit_form,
            outdata.eb11_infobereit_zeitpunkt,
            outdata.eb11_wwkomplsatz,
            outdata.eb11_user
        from
            awh_erhebungsbogen_11
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_11;

    procedure prc_set_erhebungsbogen_11 (
        pi_n_asy_lfd_nr                number,
        pi_n_eb11_lfd_nr               number,
        pi_cl_eb11_satz_pers_daten     clob,
        pi_vc_eb11_nakodv_form         varchar2,
        pi_vc_eb11_nakodv_zeitpunkt    varchar2,
        pi_vc_eb11_kodsb_form          varchar2,
        pi_vc_eb11_kodsb_zeitpunkt     varchar2,
        pi_vc_eb11_zweckrecht_form     varchar2,
        pi_vc_eb11_zweckrecht_zp       varchar2,
        pi_vc_eb11_empfkat_form        varchar2,
        pi_vc_eb11_empfkat_zeitpunkt   varchar2,
        pi_vc_eb11_dauerpers_form      varchar2,
        pi_vc_eb11_dauerpers_zeitpunkt varchar2,
        pi_vc_eb11_widerspruch_form    varchar2,
        pi_vc_eb11_widerspruch_zp      varchar2,
        pi_vc_eb11_einrueck_form       varchar2,
        pi_vc_eb11_einrueck_zeitpunkt  varchar2,
        pi_vc_eb11_beschrecht_form     varchar2,
        pi_vc_eb11_beschrecht_zp       varchar2,
        pi_vc_eb11_infobereit_form     varchar2,
        pi_vc_eb11_infobereit_zp       varchar2,
        pi_vc_eb11_wwkomplsatz         varchar2,
        pi_vc_eb11_user                varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_11 dest
        using (
            select
                pi_n_asy_lfd_nr                as asy_lfd_nr,
                pi_n_eb11_lfd_nr               as eb11_lfd_nr,
                pi_cl_eb11_satz_pers_daten     as eb11_satz_pers_daten,
                pi_vc_eb11_nakodv_form         as eb11_nakodv_form,
                pi_vc_eb11_nakodv_zeitpunkt    as eb11_nakodv_zeitpunkt,
                pi_vc_eb11_kodsb_form          as eb11_kodsb_form,
                pi_vc_eb11_kodsb_zeitpunkt     as eb11_kodsb_zeitpunkt,
                pi_vc_eb11_zweckrecht_form     as eb11_zweckrecht_form,
                pi_vc_eb11_zweckrecht_zp       as eb11_zweckrecht_zeitpunkt,
                pi_vc_eb11_empfkat_form        as eb11_empfkat_form,
                pi_vc_eb11_empfkat_zeitpunkt   as eb11_empfkat_zeitpunkt,
                pi_vc_eb11_dauerpers_form      as eb11_dauerpers_form,
                pi_vc_eb11_dauerpers_zeitpunkt as eb11_dauerpers_zeitpunkt,
                pi_vc_eb11_widerspruch_form    as eb11_widerspruch_form,
                pi_vc_eb11_widerspruch_zp      as eb11_widerspruch_zeitpunkt,
                pi_vc_eb11_einrueck_form       as eb11_einrueck_form,
                pi_vc_eb11_einrueck_zeitpunkt  as eb11_einrueck_zeitpunkt,
                pi_vc_eb11_beschrecht_form     as eb11_beschrecht_form,
                pi_vc_eb11_beschrecht_zp       as eb11_beschrecht_zeitpunkt,
                pi_vc_eb11_infobereit_form     as eb11_infobereit_form,
                pi_vc_eb11_infobereit_zp       as eb11_infobereit_zeitpunkt,
                pi_vc_eb11_wwkomplsatz         as eb11_wwkomplsatz,
                pi_vc_eb11_user                as eb11_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb11_satz_pers_daten = nvl(src.eb11_satz_pers_daten, dest.eb11_satz_pers_daten),
            dest.eb11_nakodv_form = nvl(src.eb11_nakodv_form, dest.eb11_nakodv_form),
            dest.eb11_nakodv_zeitpunkt = nvl(src.eb11_nakodv_zeitpunkt, dest.eb11_nakodv_zeitpunkt),
            dest.eb11_kodsb_form = nvl(src.eb11_kodsb_form, dest.eb11_kodsb_form),
            dest.eb11_kodsb_zeitpunkt = nvl(src.eb11_kodsb_zeitpunkt, dest.eb11_kodsb_zeitpunkt),
            dest.eb11_zweckrecht_form = nvl(src.eb11_zweckrecht_form, dest.eb11_zweckrecht_form),
            dest.eb11_zweckrecht_zeitpunkt = nvl(src.eb11_zweckrecht_zeitpunkt, dest.eb11_zweckrecht_zeitpunkt),
            dest.eb11_empfkat_form = nvl(src.eb11_empfkat_form, dest.eb11_empfkat_form),
            dest.eb11_empfkat_zeitpunkt = nvl(src.eb11_empfkat_zeitpunkt, dest.eb11_empfkat_zeitpunkt),
            dest.eb11_dauerpers_form = nvl(src.eb11_dauerpers_form, dest.eb11_dauerpers_form),
            dest.eb11_dauerpers_zeitpunkt = nvl(src.eb11_dauerpers_zeitpunkt, dest.eb11_dauerpers_zeitpunkt),
            dest.eb11_widerspruch_form = nvl(src.eb11_widerspruch_form, dest.eb11_widerspruch_form),
            dest.eb11_widerspruch_zeitpunkt = nvl(src.eb11_widerspruch_zeitpunkt, dest.eb11_widerspruch_zeitpunkt),
            dest.eb11_einrueck_form = nvl(src.eb11_einrueck_form, dest.eb11_einrueck_form),
            dest.eb11_einrueck_zeitpunkt = nvl(src.eb11_einrueck_zeitpunkt, dest.eb11_einrueck_zeitpunkt),
            dest.eb11_beschrecht_form = nvl(src.eb11_beschrecht_form, dest.eb11_beschrecht_form),
            dest.eb11_beschrecht_zeitpunkt = nvl(src.eb11_beschrecht_zeitpunkt, dest.eb11_beschrecht_zeitpunkt),
            dest.eb11_infobereit_form = nvl(src.eb11_infobereit_form, dest.eb11_infobereit_form),
            dest.eb11_infobereit_zeitpunkt = nvl(src.eb11_infobereit_zeitpunkt, dest.eb11_infobereit_zeitpunkt),
            dest.eb11_wwkomplsatz = nvl(src.eb11_wwkomplsatz, dest.eb11_wwkomplsatz),
            dest.eb11_user = nvl(src.eb11_user, dest.eb11_user)
        when not matched then
        insert (
            asy_lfd_nr,
            eb11_satz_pers_daten,
            eb11_nakodv_form,
            eb11_nakodv_zeitpunkt,
            eb11_kodsb_form,
            eb11_kodsb_zeitpunkt,
            eb11_zweckrecht_form,
            eb11_zweckrecht_zeitpunkt,
            eb11_empfkat_form,
            eb11_empfkat_zeitpunkt,
            eb11_dauerpers_form,
            eb11_dauerpers_zeitpunkt,
            eb11_widerspruch_form,
            eb11_widerspruch_zeitpunkt,
            eb11_einrueck_form,
            eb11_einrueck_zeitpunkt,
            eb11_beschrecht_form,
            eb11_beschrecht_zeitpunkt,
            eb11_infobereit_form,
            eb11_infobereit_zeitpunkt,
            eb11_wwkomplsatz,
            eb11_user )
        values
            ( src.asy_lfd_nr,
              src.eb11_satz_pers_daten,
              src.eb11_nakodv_form,
              src.eb11_nakodv_zeitpunkt,
              src.eb11_kodsb_form,
              src.eb11_kodsb_zeitpunkt,
              src.eb11_zweckrecht_form,
              src.eb11_zweckrecht_zeitpunkt,
              src.eb11_empfkat_form,
              src.eb11_empfkat_zeitpunkt,
              src.eb11_dauerpers_form,
              src.eb11_dauerpers_zeitpunkt,
              src.eb11_widerspruch_form,
              src.eb11_widerspruch_zeitpunkt,
              src.eb11_einrueck_form,
              src.eb11_einrueck_zeitpunkt,
              src.eb11_beschrecht_form,
              src.eb11_beschrecht_zeitpunkt,
              src.eb11_infobereit_form,
              src.eb11_infobereit_zeitpunkt,
              src.eb11_wwkomplsatz,
              src.eb11_user );

    end prc_set_erhebungsbogen_11;

    function fkt_get_erhebungsbogen_12 (
        pi_n_asy_lfd_nr number
    ) return tperhebungsbogen12
        pipelined
    as
        outdata terhebungsbogen12record;
    begin
        select
            eb12_lfd_nr,
            asy_lfd_nr,
            eb12_voreinstellungen_auto,
            eb12_ve_auto_erlaeuterung,
            eb12_user
        into
            outdata.eb12_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.eb12_voreinstellungen_auto,
            outdata.eb12_ve_auto_erlaeuterung,
            outdata.eb12_user
        from
            awh_erhebungsbogen_12
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_erhebungsbogen_12;

    procedure prc_set_erhebungsbogen_12 (
        pi_n_asy_lfd_nr        number,
        pi_n_eb12_lfd_nr       number,
        pi_n_eb12_ve_auto      number,
        pi_vc_eb12_ve_auto_erl varchar2,
        pi_vc_eb12_user        varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_12 dest
        using (
            select
                pi_n_asy_lfd_nr        as asy_lfd_nr,
                pi_n_eb12_lfd_nr       as eb12_lfd_nr,
                pi_n_eb12_ve_auto      as eb12_voreinstellungen_auto,
                pi_vc_eb12_ve_auto_erl as eb12_ve_auto_erlaeuterung,
                pi_vc_eb12_user        as eb12_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb12_voreinstellungen_auto = src.eb12_voreinstellungen_auto,
            dest.eb12_ve_auto_erlaeuterung = src.eb12_ve_auto_erlaeuterung,
            dest.eb12_user = src.eb12_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb12_voreinstellungen_auto,
            eb12_ve_auto_erlaeuterung,
            eb12_user )
        values
            ( src.asy_lfd_nr,
              src.eb12_voreinstellungen_auto,
              src.eb12_ve_auto_erlaeuterung,
              src.eb12_user );

    end prc_set_erhebungsbogen_12;

    function fkt_get_befuellungsgrad (
        pi_n_asy_lfd_nr number
    ) return tpbefuellungsgrad
        pipelined
    as
        outdata tbefuellungsgradrecord;
    begin
        select
            bef_lfd_nr,
            beg_lfd_nr,
            asy_lfd_nr,
            bef_kommentar --wird in der GUI nichtmehr benutzt 05.12.24
        into
            outdata.bef_lfd_nr,
            outdata.beg_lfd_nr,
            outdata.asy_lfd_nr,
            outdata.bef_kommentar ----wird in der GUI nichtmehr benutzt 05.12.24 oder ggf. bei den Prozessen verwendet bitte prüfen 20.01.2025
        from
            awh_eudsgvo_befuell
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_befuellungsgrad;

    procedure prc_set_befuellungsgrad (
        pi_n_asy_lfd_nr number,
        pi_n_beg_lfd_nr number
    ) as
    begin
        merge into awh_eudsgvo_befuell dest
        using (
            select
                pi_n_asy_lfd_nr as asy_lfd_nr,
                pi_n_beg_lfd_nr as beg_lfd_nr
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.beg_lfd_nr = src.beg_lfd_nr
        when not matched then
        insert (
            asy_lfd_nr,
            beg_lfd_nr )
        values
            ( src.asy_lfd_nr,
              src.beg_lfd_nr );

    end prc_set_befuellungsgrad;

    procedure prc_set_infosec_anlagenkat (
        pi_n_asy_lfd_nr number,
        pi_vc_ank_kat3  varchar2,
        pi_vc_ank_funk  varchar2,
        pi_vc_app_user  varchar2
    ) as
    begin
        merge into awh_infosec_anlagenkat dest
        using (
            select
                pi_n_asy_lfd_nr as asy_lfd_nr,
                pi_vc_ank_kat3  as ank_kat3,
                pi_vc_ank_funk  as ank_funk,
                pi_vc_app_user  as ank_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.ank_kat3 = src.ank_kat3,
            dest.ank_funk = src.ank_funk,
            dest.ank_user = src.ank_user
        when not matched then
        insert (
            asy_lfd_nr,
            ank_kat3,
            ank_funk,
            ank_user )
        values
            ( src.asy_lfd_nr,
              src.ank_kat3,
              src.ank_funk,
              src.ank_user );

    end prc_set_infosec_anlagenkat;

  /*FUNCTION FKT_GET_ANLAGENKAT_TEXT(PI_N_ASY_LFD_NR      NUMBER,
                                   PI_VC_ANK_FUNK       VARCHAR2) RETURN VARCHAR2
  AS
    retVal VARCHAR2(200);
  BEGIN

    for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
            SELECT trim(regexp_substr(PI_VC_ANK_FUNK, '[^:]+', 1, LEVEL)) FKL_UID
            FROM dual
            CONNECT BY instr(PI_VC_ANK_FUNK, ':', 1, LEVEL - 1) > 0
        )
        loop
            if rsk.FKL_UID is not null then
                select '1' into retVal from DUAL;
            end if;
        end loop;    

    RETURN retVal;--*/

    procedure prc_set_hosts_und_cluster (
        pi_n_asy_lfd_nr  number,
        pi_vc_vvg_gvb    varchar2,
        pi_vc_vvg_vms    varchar2,
        pi_vc_vvg_geraet varchar2,
        pi_vc_vvg_elgrt  varchar2,
        pi_vc_vvg_infclu varchar2,
        pi_vc_vvg_was    varchar2,
        pi_vc_app_user   varchar2
    ) as
    begin

    --Virtuelle Maschiene PI_VC_VVG_VMS
        begin
            delete from awh_mtn_sys_vm
            where
                    asy_lfd_nr = pi_n_asy_lfd_nr
                and instr(':'
                          || pi_vc_vvg_vms
                          || ':', ':'
                                  || vm_uid
                                  || ':') = 0; -- uid nicht im String vorhanden
        exception
            when no_data_found then
                null;
        end;

      -- Ãbernehmen der Eingabedaten  
      --r_AWH_MTN_SYS_GRT.ASY_LFD_NR            := PI_N_ASY_LFD_NR;

      -- EinfÃ¼gen der hinzugefÃ¼gten VerknÃ¼pfungen
        for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
            select
                trim(regexp_substr(pi_vc_vvg_vms, '[^:]+', 1, level)) vm_uid
            from
                dual
            connect by
                instr(pi_vc_vvg_vms, ':', 1, level - 1) > 0
            minus
            -- AusschlieÃen der bereits gespeicherten VerknÃ¼pfungen
            select
                to_char(vm_uid)
            from
                awh_mtn_sys_vm
            where
                asy_lfd_nr = pi_n_asy_lfd_nr
        ) loop
            if rsk.vm_uid is not null then
                insert into awh_mtn_sys_vm (
                    sv_uid,
                    asy_lfd_nr,
                    vm_uid,
                    sv_user,
                    sv_timestamp
                ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                           pi_n_asy_lfd_nr,
                           rsk.vm_uid,
                           pi_vc_app_user,
                           sysdate );

            end if;
        end loop;

    --GerÃ¤te
        begin
            delete from awh_mtn_sys_grt
            where
                    asy_lfd_nr = pi_n_asy_lfd_nr
                and instr(':'
                          || pi_vc_vvg_geraet
                          || ':', ':'
                                  || grt_uid
                                  || ':') = 0; -- uid nicht im String vorhanden
        exception
            when no_data_found then
                null;
        end;

      -- Ãbernehmen der Eingabedaten  
      --r_AWH_MTN_SYS_GRT.ASY_LFD_NR            := PI_N_ASY_LFD_NR;

      -- EinfÃ¼gen der hinzugefÃ¼gten VerknÃ¼pfungen
        for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
            select
                trim(regexp_substr(pi_vc_vvg_geraet, '[^:]+', 1, level)) grt_uid
            from
                dual
            connect by
                instr(pi_vc_vvg_geraet, ':', 1, level - 1) > 0
            minus
            -- AusschlieÃen der bereits gespeicherten VerknÃ¼pfungen
            select
                to_char(grt_uid)
            from
                awh_mtn_sys_grt
            where
                asy_lfd_nr = pi_n_asy_lfd_nr
        ) loop
            if rsk.grt_uid is not null then
                insert into awh_mtn_sys_grt (
                    sgr_asy_grt,
                    asy_lfd_nr,
                    grt_uid,
                    sgr_user,
                    sgr_timestamp
                ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                           pi_n_asy_lfd_nr,
                           rsk.grt_uid,
                           pi_vc_app_user,
                           sysdate );

            end if;
        end loop;

    --elementare GerÃ¤te noch nicht nutzbar

        begin
            delete from awh_mtn_sys_egt
            where
                    asy_lfd_nr = pi_n_asy_lfd_nr
                and instr(':'
                          || pi_vc_vvg_elgrt
                          || ':', ':'
                                  || egt_uid
                                  || ':') = 0; -- uid nicht im String vorhanden
        exception
            when no_data_found then
                null;
        end;

      -- Ãbernehmen der Eingabedaten  
      --r_AWH_MTN_SYS_EGT.ASY_LFD_NR            := PI_N_ASY_LFD_NR;

      -- EinfÃ¼gen der hinzugefÃ¼gten VerknÃ¼pfungen
        for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
            select
                trim(regexp_substr(pi_vc_vvg_elgrt, '[^:]+', 1, level)) egt_uid
            from
                dual
            connect by
                instr(pi_vc_vvg_elgrt, ':', 1, level - 1) > 0
            minus
            -- AusschlieÃen der bereits gespeicherten VerknÃ¼pfungen
            select
                to_char(egt_uid)
            from
                awh_mtn_sys_egt
            where
                asy_lfd_nr = pi_n_asy_lfd_nr
        ) loop
            if rsk.egt_uid is not null then
                insert into awh_mtn_sys_egt (
                    seg_asy_egt,
                    asy_lfd_nr,
                    egt_uid,
                    seg_user,
                    seg_timestamp
                ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                           pi_n_asy_lfd_nr,
                           rsk.egt_uid,
                           pi_vc_app_user,
                           sysdate );

            end if;
        end loop;--*/

    --Informationscluster

        begin
            delete from awh_mtn_sys_icl
            where
                    asy_lfd_nr = pi_n_asy_lfd_nr
                and instr(':'
                          || pi_vc_vvg_infclu
                          || ':', ':'
                                  || icl_uid
                                  || ':') = 0; -- uid nicht im String vorhanden
        exception
            when no_data_found then
                null;
        end;

      -- Ãbernehmen der Eingabedaten  
      --r_AWH_MTN_SYS_GRT.ASY_LFD_NR            := PI_N_ASY_LFD_NR;

      -- EinfÃ¼gen der hinzugefÃ¼gten VerknÃ¼pfungen
        for rsk in (
            -- Zerlegen des :-getennten Strings in einzelne UIDs
            select
                trim(regexp_substr(pi_vc_vvg_infclu, '[^:]+', 1, level)) icl_uid
            from
                dual
            connect by
                instr(pi_vc_vvg_infclu, ':', 1, level - 1) > 0
            minus
            -- AusschlieÃen der bereits gespeicherten VerknÃ¼pfungen
            select
                to_char(icl_uid)
            from
                awh_mtn_sys_icl
            where
                asy_lfd_nr = pi_n_asy_lfd_nr
        ) loop
            if rsk.icl_uid is not null then
                insert into awh_mtn_sys_icl (
                    sic_asy_icl,
                    asy_lfd_nr,
                    icl_uid,
                    sic_user,
                    sic_timestamp
                ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                           pi_n_asy_lfd_nr,
                           rsk.icl_uid,
                           pi_vc_app_user,
                           sysdate );

            end if;
        end loop;--*/

    /*MERGE INTO AWH_CONFM_VM_UND_CO dest
    USING (
        SELECT
            PI_N_ASY_LFD_NR  AS ASY_LFD_NR,
            PI_VC_VVG_GVB    AS VVG_GVB,
            PI_VC_VVG_VMS    AS VVG_VMS,
            PI_VC_VVG_GERAET AS VVG_GERAET,
            PI_VC_VVG_WAS    AS VVG_WAS,
            PI_VC_APP_USER   AS VVG_USER
        FROM
            DUAL) src
    ON (src.ASY_LFD_NR = dest.ASY_LFD_NR)
    WHEN MATCHED THEN
        UPDATE
        SET
            dest.VVG_GVB    = src.VVG_GVB,
            dest.VVG_VMS    = src.VVG_VMS,
            dest.VVG_GERAET = src.VVG_GERAET,
            dest.VVG_WAS    = src.VVG_WAS,
            dest.VVG_USER   = src.VVG_USER
    WHEN NOT MATCHED THEN
        INSERT
        (
            ASY_LFD_NR,
            VVG_GVB,
            VVG_VMS,
            VVG_GERAET,
            VVG_WAS,
            VVG_USER
        )
        VALUES
        (
            src.ASY_LFD_NR,
            src.VVG_GVB,
            src.VVG_VMS,
            src.VVG_GERAET,
            src.VVG_WAS,
            src.VVG_USER
        );*/
    end prc_set_hosts_und_cluster;

    procedure prc_set_awh_system (
        pi_n_asy_lfd_nr      number,
        pi_vc_asy_name       varchar2,
        pi_vc_asy_funktion   varchar2,
        pi_vc_asy_abgrenzung varchar2,
        pi_vc_asy_kommentar  varchar2,
        pi_vc_asy_aufrufpfad varchar2,
        pi_d_asy_einfuehrung date,
        pi_vc_asy_user       varchar2,
        pi_n_asy_aktiv       number,
        pi_fbz_uid           number,
        pi_fbk_uid           number,
        pi_fie_uid           number,
        pi_akt_uid           number
    ) as
    begin
        merge into awh_system dest
        using (
            select
                pi_n_asy_lfd_nr      as asy_lfd_nr,
                pi_vc_asy_name       as asy_name,
                pi_vc_asy_funktion   as asy_funktion,
                pi_vc_asy_abgrenzung as asy_abgrenzung,
                pi_vc_asy_kommentar  as asy_kommentar,
                pi_vc_asy_aufrufpfad as asy_aufrufpfad,
                pi_d_asy_einfuehrung as asy_einfuehrung,
                pi_vc_asy_user       as asy_user,
                pi_n_asy_aktiv       as asy_aktiv,
                pi_fbz_uid           as fbz_uid,
                pi_fbk_uid           as fbk_uid,
                pi_fie_uid           as fie_uid,
                pi_akt_uid           as akt_uid
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.asy_name = src.asy_name,
            dest.asy_funktion = src.asy_funktion,
            dest.asy_abgrenzung = src.asy_abgrenzung,
            dest.asy_kommentar = src.asy_kommentar,
            dest.asy_aufrufpfad = src.asy_aufrufpfad,
            dest.asy_einfuehrung = src.asy_einfuehrung,
            dest.asy_user = src.asy_user,
            dest.asy_aktiv = src.asy_aktiv,
            dest.fbz_uid = src.fbz_uid,
            dest.fbk_uid = src.fbk_uid,
            dest.fie_uid = src.fie_uid,
            dest.akt_uid = src.akt_uid
        when not matched then
        insert (
            asy_name,
            asy_funktion,
            asy_abgrenzung,
            asy_kommentar,
            asy_aufrufpfad,
            asy_einfuehrung,
            asy_user,
            asy_aktiv,
            fbz_uid,
            fbk_uid,
            fie_uid,
            akt_uid )
        values
            ( src.asy_name,
              src.asy_funktion,
              src.asy_abgrenzung,
              src.asy_kommentar,
              src.asy_aufrufpfad,
              src.asy_einfuehrung,
              src.asy_user,
              src.asy_aktiv,
              src.fbz_uid,
              src.fbk_uid,
              src.fie_uid,
              src.akt_uid );

    end prc_set_awh_system;

    procedure prc_set_awh_system_only_funk (
        pi_n_asy_lfd_nr    number,
        pi_vc_asy_funktion varchar2,
        pi_vc_asy_user     varchar2
    ) as
    begin
        merge into awh_system dest
        using (
            select
                pi_n_asy_lfd_nr    as asy_lfd_nr,
                pi_vc_asy_funktion as asy_funktion,
                pi_vc_asy_user     as asy_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.asy_funktion = src.asy_funktion,
            dest.asy_user = src.asy_user
        when not matched then
        insert (
            asy_funktion,
            asy_user )
        values
            ( src.asy_funktion,
              src.asy_user );

    end prc_set_awh_system_only_funk;

    procedure prc_set_infosec_zul_nutzung (
        pi_n_asy_lfd_nr          number,
        pi_n_zdf_lfd_nr          number,
        pi_vc_zul_referenz_regel varchar2,
        pi_n_zul_kennzeichnung   number,
        pi_vc_zul_user           varchar2
    ) as
    begin
        merge into awh_infosec_zul_nutzung dest
        using (
            select
                pi_n_asy_lfd_nr          as asy_lfd_nr,
                pi_n_zdf_lfd_nr          as zdf_lfd_nr,
                pi_vc_zul_referenz_regel as zul_referenz_regel,
                pi_n_zul_kennzeichnung   as zul_kennzeichnung,
                pi_vc_zul_user           as zul_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.zdf_lfd_nr = src.zdf_lfd_nr,
            dest.zul_referenz_regel = src.zul_referenz_regel,
            dest.zul_kennzeichnung = src.zul_kennzeichnung,
            dest.zul_user = src.zul_user
        when not matched then
        insert (
            asy_lfd_nr,
            zdf_lfd_nr,
            zul_referenz_regel,
            zul_kennzeichnung,
            zul_user )
        values
            ( src.asy_lfd_nr,
              src.zdf_lfd_nr,
              src.zul_referenz_regel,
              src.zul_kennzeichnung,
              src.zul_user );

    end prc_set_infosec_zul_nutzung;

    procedure prc_set_infosec_eb7_hersteller (
        pi_n_asy_lfd_nr      number,
        pi_vc_eb7_hersteller varchar2,
        pi_vc_eb7_user       varchar2
    ) as
    begin
        merge into awh_erhebungsbogen_7 dest
        using (
            select
                pi_n_asy_lfd_nr      as asy_lfd_nr,
                pi_vc_eb7_hersteller as eb7_hersteller,
                pi_vc_eb7_user       as eb7_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.eb7_hersteller = src.eb7_hersteller,
            dest.eb7_user = src.eb7_user
        when not matched then
        insert (
            asy_lfd_nr,
            eb7_hersteller,
            eb7_user )
        values
            ( src.asy_lfd_nr,
              src.eb7_hersteller,
              src.eb7_user );

    end prc_set_infosec_eb7_hersteller;

    procedure prc_set_infosec_tom_vt (
        pi_n_asy_lfd_nr    number,
        pi_n_trv_lfd_nr    number,
        pi_n_sov_lfd_nr    number,
        pi_vc_tvt_zugsteu  varchar2,
        pi_n_tvt_berechtko number,
        pi_n_tvt_rollen    number,
        pi_n_tvt_einerolle number,
        pi_vc_tvt_zugverw  number,
        pi_n_ere_lfd_nr    number,
        pi_vc_tvt_user     varchar2
    ) as
    begin
        merge into awh_infosec_tom_vt dest
        using (
            select
                pi_n_asy_lfd_nr    as asy_lfd_nr,
                pi_n_trv_lfd_nr    as trv_lfd_nr,
                pi_n_sov_lfd_nr    as sov_lfd_nr,
                pi_vc_tvt_zugsteu  as tvt_zugsteu,
                pi_n_tvt_berechtko as tvt_berechtko,
                pi_n_tvt_rollen    as tvt_rollen,
                pi_n_tvt_einerolle as tvt_einerolle,
                pi_vc_tvt_zugverw  as tvt_zugverw,
                pi_n_ere_lfd_nr    as ere_lfd_nr,
                pi_vc_tvt_user     as tvt_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.trv_lfd_nr = src.trv_lfd_nr,
            dest.sov_lfd_nr = src.sov_lfd_nr,
            dest.tvt_zugsteu = src.tvt_zugsteu,
            dest.tvt_berechtko = src.tvt_berechtko,
            dest.tvt_rollen = src.tvt_rollen,
            dest.tvt_einerolle = src.tvt_einerolle,
            dest.tvt_zugverw = src.tvt_zugverw,
            dest.ere_lfd_nr = src.ere_lfd_nr,
            dest.tvt_user = src.tvt_user
        when not matched then
        insert (
            asy_lfd_nr,
            trv_lfd_nr,
            sov_lfd_nr,
            tvt_zugsteu,
            tvt_berechtko,
            tvt_rollen,
            tvt_einerolle,
            tvt_zugverw,
            ere_lfd_nr,
            tvt_user )
        values
            ( src.asy_lfd_nr,
              src.trv_lfd_nr,
              src.sov_lfd_nr,
              src.tvt_zugsteu,
              src.tvt_berechtko,
              src.tvt_rollen,
              src.tvt_einerolle,
              src.tvt_zugverw,
              src.ere_lfd_nr,
              src.tvt_user );

    end prc_set_infosec_tom_vt;

    procedure prc_set_infosec_tom_in (
        pi_n_asy_lfd_nr     number,
        pi_vc_tin_kontrolle number,
        pi_n_adt_lfd_nr     number,
        pi_n_chm_lfd_nr     number,
        pi_vc_tin_user      varchar2
    ) as
    begin
        merge into awh_infosec_tom_in dest
        using (
            select
                pi_n_asy_lfd_nr     as asy_lfd_nr,
                pi_vc_tin_kontrolle as tin_kontrolle,
                pi_n_adt_lfd_nr     as adt_lfd_nr,
                pi_n_chm_lfd_nr     as chm_lfd_nr,
                pi_vc_tin_user      as tin_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.tin_kontrolle = src.tin_kontrolle,
            dest.adt_lfd_nr = src.adt_lfd_nr,
            dest.chm_lfd_nr = src.chm_lfd_nr,
            dest.tin_user = src.tin_user
        when not matched then
        insert (
            asy_lfd_nr,
            tin_kontrolle,
            adt_lfd_nr,
            chm_lfd_nr,
            tin_user )
        values
            ( src.asy_lfd_nr,
              src.tin_kontrolle,
              src.adt_lfd_nr,
              src.chm_lfd_nr,
              src.tin_user );

    end prc_set_infosec_tom_in;

    procedure prc_set_infosec_tom_vf (
        pi_n_asy_lfd_nr number,
        pi_n_zet_lfd_nr number,
        pi_n_ueb_lfd_nr number,
        pi_n_asf_lfd_nr number,
        pi_vc_tvf_user  varchar2
    ) as
    begin
        merge into awh_infosec_tom_vf dest
        using (
            select
                pi_n_asy_lfd_nr as asy_lfd_nr,
                pi_n_zet_lfd_nr as zet_lfd_nr,
                pi_n_ueb_lfd_nr as ueb_lfd_nr,
                pi_n_asf_lfd_nr as asf_lfd_nr,
                pi_vc_tvf_user  as tvf_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.zet_lfd_nr = src.zet_lfd_nr,
            dest.ueb_lfd_nr = src.ueb_lfd_nr,
            dest.asf_lfd_nr = src.asf_lfd_nr,
            dest.tvf_user = src.tvf_user
        when not matched then
        insert (
            asy_lfd_nr,
            zet_lfd_nr,
            ueb_lfd_nr,
            asf_lfd_nr,
            tvf_user )
        values
            ( src.asy_lfd_nr,
              src.zet_lfd_nr,
              src.ueb_lfd_nr,
              src.asf_lfd_nr,
              src.tvf_user );

    end prc_set_infosec_tom_vf;

    procedure prc_set_infosec_tom_at (
        pi_n_asy_lfd_nr number,
        pi_n_mfa_lfd_nr number,
        pi_vc_tat_user  varchar2
    ) as
    begin
        merge into awh_infosec_tom_at dest
        using (
            select
                pi_n_asy_lfd_nr as asy_lfd_nr,
                pi_n_mfa_lfd_nr as mfa_lfd_nr,
                pi_vc_tat_user  as tat_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.mfa_lfd_nr = src.mfa_lfd_nr,
            dest.tat_user = src.tat_user
        when not matched then
        insert (
            asy_lfd_nr,
            mfa_lfd_nr,
            tat_user )
        values
            ( src.asy_lfd_nr,
              src.mfa_lfd_nr,
              src.tat_user );

    end prc_set_infosec_tom_at;

    procedure prc_set_infosec_comp (
        pi_n_asy_lfd_nr      number,
        pi_n_cop_dsgvo       number,
        pi_n_cop_betrvg      number,
        pi_n_cop_kritisv     number,
        pi_vc_cop_elem_infra varchar2,
        pi_vc_cop_user       varchar2
    ) as
    begin
        merge into awh_infosec_comp dest
        using (
            select
                pi_n_asy_lfd_nr      as asy_lfd_nr,
                pi_n_cop_dsgvo       as cop_dsgvo,
                pi_n_cop_betrvg      as cop_betrvg,
                pi_n_cop_kritisv     as cop_kritisv,
                pi_vc_cop_elem_infra as cop_elem_infra,
                pi_vc_cop_user       as cop_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.cop_dsgvo = src.cop_dsgvo,
            dest.cop_betrvg = src.cop_betrvg,
            dest.cop_kritisv = src.cop_kritisv,
            dest.cop_elem_infra = src.cop_elem_infra,
            dest.cop_user = src.cop_user
        when not matched then
        insert (
            asy_lfd_nr,
            cop_dsgvo,
            cop_betrvg,
            cop_kritisv,
            cop_elem_infra,
            cop_user )
        values
            ( src.asy_lfd_nr,
              src.cop_dsgvo,
              src.cop_betrvg,
              src.cop_kritisv,
              src.cop_elem_infra,
              src.cop_user );

    end prc_set_infosec_comp;

    procedure prc_set_infosec_geschaeftskritisch (
        pi_n_asy_lfd_nr number,
        pi_n_gek_lfd_nr number,
        pi_vc_gks_user  varchar2
    ) as
    begin
        merge into awh_infosec_geschaeftskritisch dest
        using (
            select
                pi_n_asy_lfd_nr as asy_lfd_nr,
                pi_n_gek_lfd_nr as gek_lfd_nr,
                pi_vc_gks_user  as gks_user
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.gek_lfd_nr = src.gek_lfd_nr
        when not matched then
        insert (
            asy_lfd_nr,
            gek_lfd_nr,
            gks_user )
        values
            ( src.asy_lfd_nr,
              src.gek_lfd_nr,
              src.gks_user );

    end prc_set_infosec_geschaeftskritisch;

    procedure prc_set_infosec_tom_handbuch (
        pi_n_asy_lfd_nr        number,
        pi_vc_hnb_patch_chng   varchar2,
        pi_vc_hnb_zugangsverw  varchar2,
        pi_vc_hnb_wiederanlauf varchar2,
        pi_vc_hnb_buch1        varchar2,
        pi_vc_hnb_buch2        varchar2,
        pi_vc_hnb_buch3        varchar2,
        pi_vc_hnb_buch4        varchar2,
        pi_vc_hnb_buch5        varchar2
    ) as
    begin
        merge into awh_infosec_tom_handbuch dest
        using (
            select
                pi_n_asy_lfd_nr        as asy_lfd_nr,
                pi_vc_hnb_patch_chng   as hnb_patch_chng,
                pi_vc_hnb_zugangsverw  as hnb_zugangsverw,
                pi_vc_hnb_wiederanlauf as hnb_wiederanlauf,
                pi_vc_hnb_buch1        as hnb_buch1,
                pi_vc_hnb_buch2        as hnb_buch2,
                pi_vc_hnb_buch3        as hnb_buch3,
                pi_vc_hnb_buch4        as hnb_buch4,
                pi_vc_hnb_buch5        as hnb_buch5
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.hnb_patch_chng = src.hnb_patch_chng,
            dest.hnb_zugangsverw = src.hnb_zugangsverw,
            dest.hnb_wiederanlauf = src.hnb_wiederanlauf,
            dest.hnb_buch1 = src.hnb_buch1,
            dest.hnb_buch2 = src.hnb_buch2,
            dest.hnb_buch3 = src.hnb_buch3,
            dest.hnb_buch4 = src.hnb_buch4,
            dest.hnb_buch5 = src.hnb_buch5
        when not matched then
        insert (
            asy_lfd_nr,
            hnb_patch_chng,
            hnb_zugangsverw,
            hnb_wiederanlauf,
            hnb_buch1,
            hnb_buch2,
            hnb_buch3,
            hnb_buch4,
            hnb_buch5 )
        values
            ( src.asy_lfd_nr,
              src.hnb_patch_chng,
              src.hnb_zugangsverw,
              src.hnb_wiederanlauf,
              src.hnb_buch1,
              src.hnb_buch2,
              src.hnb_buch3,
              src.hnb_buch4,
              src.hnb_buch5 );

    end prc_set_infosec_tom_handbuch;

    function fkt_save_allowed (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    ) return number as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_erhb_lock
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        if n_count > 0 then
            select
                count(1)
            into n_count
            from
                awh_erhb_lock
            where
                    asy_lfd_nr = pi_n_asy_lfd_nr
                and erb_user = upper(pi_vc_user);

            if n_count > 0 then
                return 1;
            else
                return 0;
            end if;
        else
            return 0;
        end if;

    end fkt_save_allowed;

    function fkt_lock_allowed (
        pi_n_asy_lfd_nr number
    ) return number as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_erhb_lock
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        if n_count = 0 then
            return 1;
        else
            return 0;
        end if;
    end fkt_lock_allowed;

    procedure prc_set_lock (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    ) as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_erhb_lock
        where
            asy_lfd_nr = pi_n_asy_lfd_nr;

        if n_count = 0 then
            insert into awh_erhb_lock (
                asy_lfd_nr,
                erb_user,
                erb_timestamp
            ) values ( pi_n_asy_lfd_nr,
                       pi_vc_user,
                       sysdate );

        else
            raise_application_error(-20010, 'Das System ist bereits ausgecheckt.');
        end if;

    end prc_set_lock;

    procedure prc_reset_lock (
        pi_n_asy_lfd_nr number,
        pi_vc_user      varchar2
    ) as
    begin
        delete from awh_erhb_lock
        where
                asy_lfd_nr = pi_n_asy_lfd_nr
            and erb_user = pi_vc_user;

    end prc_reset_lock;

    procedure prc_copy_system (
        pi_n_src_asy_lfd_nr  number,
        pi_n_dest_asy_lfd_nr number
    ) as
        src_asy  number;
        dest_asy number;
        cnt      number;
    begin
        src_asy := pi_n_src_asy_lfd_nr;
        dest_asy := pi_n_dest_asy_lfd_nr;
        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                per_lfd_nr_ausf_per,
                erh_datum,
                erh_user
            from
                awh_erhebungsbogen
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen(datensatz.asy_lfd_nr, null, datensatz.per_lfd_nr_ausf_per, datensatz.erh_datum, datensatz.erh_user
            );
        end loop;

        for datensatz in (
            select
                eb1_verarb_persdata,
                eb1_name_anschrift,
                link_zum_anhang,
                eb1_loeschkonzept,
                eb1_user,
                dest_asy as asy_lfd_nr,
                eb1_inakt_persdata
            from
                awh_erhebungsbogen_1
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_1(datensatz.asy_lfd_nr, null, datensatz.eb1_inakt_persdata, datensatz.eb1_verarb_persdata
            , datensatz.eb1_name_anschrift,
                                                     datensatz.link_zum_anhang, datensatz.eb1_loeschkonzept, datensatz.eb1_user);
        end loop;

        select
            count(erf_lfd_nr)
        into cnt
        from
            awh_erheb_1_fachbereich
        where
            asy_lfd_nr = dest_asy;

        if cnt > 0 then
            delete from awh_erheb_1_fachbereich
            where
                asy_lfd_nr = dest_asy;

        end if;
        insert into awh_erheb_1_fachbereich (
            asy_lfd_nr,
            vet_lfd_nr,
            per_lfd_nr,
            buu_lfd_nr,
            erf_user
        )
            select
                dest_asy as asy_lfd_nr,
                vet_lfd_nr,
                per_lfd_nr,
                buu_lfd_nr,
                erf_user
            from
                awh_erheb_1_fachbereich
            where
                asy_lfd_nr = src_asy;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb2_zweck_persdaten,
                eb2_spezialgesetz_regel,
                eb2_einwilligung,
                eb2_kollektivvereinbarung,
                eb2_beschaeftigung,
                eb2_vertragsanbahnung,
                eb2_interessenabwaegung,
                eb2_user
            from
                awh_erhebungsbogen_2
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_2(datensatz.asy_lfd_nr, null, datensatz.eb2_zweck_persdaten, datensatz.eb2_spezialgesetz_regel
            , datensatz.eb2_einwilligung,
                                                     datensatz.eb2_kollektivvereinbarung, datensatz.eb2_beschaeftigung, datensatz.eb2_vertragsanbahnung
                                                     , datensatz.eb2_interessenabwaegung, datensatz.eb2_user);
        end loop;

        select
            count(eb3_lfd_nr)
        into cnt
        from
            awh_erhebungsbogen_3
        where
            asy_lfd_nr = dest_asy;

        if cnt > 0 then
            delete from awh_erhebungsbogen_3
            where
                asy_lfd_nr = dest_asy;

        end if;
        insert into awh_erhebungsbogen_3 (
            asy_lfd_nr,
            eb3_user
        )
            select
                dest_asy as asy_lfd_nr,
                eb3_user
            from
                awh_erhebungsbogen_3
            where
                asy_lfd_nr = src_asy;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb5_internestelle_dwi,
                eb5_artdaten_dwi,
                eb5_zweck_dwi,
                eb5_externestelle_dwe,
                eb5_artdaten_dwe,
                eb5_zweck_dwe,
                eb5_staat_dws,
                eb5_artdaten_dws,
                eb5_zweck_dws,
                eb5_user
            from
                awh_erhebungsbogen_5
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_5(datensatz.asy_lfd_nr, null, datensatz.eb5_internestelle_dwi, datensatz.eb5_artdaten_dwi
            , datensatz.eb5_zweck_dwi,
                                                     datensatz.eb5_externestelle_dwe, datensatz.eb5_artdaten_dwe, datensatz.eb5_zweck_dwe
                                                     , datensatz.eb5_staat_dws, datensatz.eb5_artdaten_dws,
                                                     datensatz.eb5_zweck_dws, datensatz.eb5_user);
        end loop;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb6_aufbewloeschfrist,
                eb6_loeschregeln,
                eb6_user
            from
                awh_erhebungsbogen_6
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_6(datensatz.asy_lfd_nr, null, datensatz.eb6_aufbewloeschfrist, datensatz.eb6_loeschregeln
            , datensatz.eb6_user);
        end loop;

        select
            count(eb7_lfd_nr)
        into cnt
        from
            awh_erhebungsbogen_7
        where
            asy_lfd_nr = dest_asy;

        if cnt > 0 then
            delete from awh_erhebungsbogen_7
            where
                asy_lfd_nr = dest_asy;

        end if;
        insert into awh_erhebungsbogen_7 (
            asy_lfd_nr,
            eb7_hersteller,
            eb7_backend,
            eb7_schnittstellen,
            eb7_user
        )
            select
                dest_asy as asy_lfd_nr,
                eb7_hersteller,
                eb7_backend,
                eb7_schnittstellen,
                eb7_user
            from
                awh_erhebungsbogen_7
            where
                asy_lfd_nr = src_asy;

        select
            count(eb8_lfd_nr)
        into cnt
        from
            awh_erhebungsbogen_8
        where
            asy_lfd_nr = dest_asy;

        if cnt > 0 then
            delete from awh_erhebungsbogen_8
            where
                asy_lfd_nr = dest_asy;

        end if;
        insert into awh_erhebungsbogen_8 (
            asy_lfd_nr,
            eb8_persgruppen,
            eb8_berechtigungsrolle,
            eb8_umfangzugriff,
            eb8_artzugriff,
            eb8_zweckzugriff,
            eb8_user
        )
            select
                dest_asy as asy_lfd_nr,
                eb8_persgruppen,
                eb8_berechtigungsrolle,
                eb8_umfangzugriff,
                eb8_artzugriff,
                eb8_zweckzugriff,
                eb8_user
            from
                awh_erhebungsbogen_8
            where
                asy_lfd_nr = src_asy;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb9_ds_itsicherheit_grund,
                eb9_risikoanalyse_erfolgt,
                eb9_massnahmen_sicherheitskonz,
                eb9_anonym_pseudonym,
                eb9_backup,
                eb9_redundantedaten,
                eb9_schutzderrechte,
                eb9_protokollierung,
                eb9_pruefung_abstaende,
                eb9_user
            from
                awh_erhebungsbogen_9
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_9(datensatz.asy_lfd_nr, null, datensatz.eb9_ds_itsicherheit_grund, datensatz.eb9_risikoanalyse_erfolgt
            , datensatz.eb9_massnahmen_sicherheitskonz,
                                                     datensatz.eb9_anonym_pseudonym, datensatz.eb9_backup, datensatz.eb9_redundantedaten
                                                     , datensatz.eb9_schutzderrechte, datensatz.eb9_protokollierung,
                                                     datensatz.eb9_pruefung_abstaende, datensatz.eb9_user);
        end loop;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb11_satz_pers_daten,
                eb11_nakodv_form,
                eb11_nakodv_zeitpunkt,
                eb11_kodsb_form,
                eb11_kodsb_zeitpunkt,
                eb11_zweckrecht_form,
                eb11_zweckrecht_zeitpunkt,
                eb11_empfkat_form,
                eb11_empfkat_zeitpunkt,
                eb11_dauerpers_form,
                eb11_dauerpers_zeitpunkt,
                eb11_widerspruch_form,
                eb11_widerspruch_zeitpunkt,
                eb11_einrueck_form,
                eb11_einrueck_zeitpunkt,
                eb11_beschrecht_form,
                eb11_beschrecht_zeitpunkt,
                eb11_infobereit_form,
                eb11_infobereit_zeitpunkt,
                eb11_user,
                eb11_wwkomplsatz
            from
                awh_erhebungsbogen_11
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_11(datensatz.asy_lfd_nr, null, datensatz.eb11_satz_pers_daten, datensatz.eb11_nakodv_form
            , datensatz.eb11_nakodv_zeitpunkt,
                                                      datensatz.eb11_kodsb_form, datensatz.eb11_kodsb_zeitpunkt, datensatz.eb11_zweckrecht_form
                                                      , datensatz.eb11_zweckrecht_zeitpunkt, datensatz.eb11_empfkat_form,
                                                      datensatz.eb11_empfkat_zeitpunkt, datensatz.eb11_dauerpers_form, datensatz.eb11_dauerpers_zeitpunkt
                                                      , datensatz.eb11_widerspruch_form, datensatz.eb11_widerspruch_zeitpunkt,
                                                      datensatz.eb11_einrueck_form, datensatz.eb11_einrueck_zeitpunkt, datensatz.eb11_beschrecht_form
                                                      , datensatz.eb11_beschrecht_zeitpunkt, datensatz.eb11_infobereit_form,
                                                      datensatz.eb11_infobereit_zeitpunkt, datensatz.eb11_wwkomplsatz, datensatz.eb11_user
                                                      );
        end loop;

        for datensatz in (
            select
                dest_asy as asy_lfd_nr,
                eb12_voreinstellungen_auto,
                eb12_ve_auto_erlaeuterung,
                eb12_user
            from
                awh_erhebungsbogen_12
            where
                asy_lfd_nr = src_asy
        ) loop
            pck_anwhandbuch.prc_set_erhebungsbogen_12(datensatz.asy_lfd_nr, null, datensatz.eb12_voreinstellungen_auto, datensatz.eb12_ve_auto_erlaeuterung
            , datensatz.eb12_user);
        end loop;

    end prc_copy_system;

  /** Wird mit CORE.AD.IS_USER_IN_ROLE_NESTED ersetzt, wird aber temporÃ¤r benÃ¶tigt.*/
    function is_user_in_role_nested (
        pi_vc_user varchar2,
        pi_vc_role varchar2
    ) return number as
        n_count number;
    begin
        select
            count(*)
        into n_count
        from
            (
                select
                    name,
                    dn,
                    val
                from
                    table ( apex_ldap.search(
                        p_host            => 'ad.netcologne.intern',
                        p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                        p_pass            => 'ZMORj3Pw',
                        p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                        p_search_filter   => 'memberOf:1.2.840.113556.1.4.1941:='
                                           || apex_escape.ldap_search_filter(  --pi_vc_role)
                                           (
                                          select
                                              val
                                          from
                                              table(apex_ldap.search(
                                                  p_host            => 'ad.netcologne.intern',
                                                  p_username        => 'CN=dienst_apex,OU=Dienste,DC=netcologne,DC=intern',
                                                  p_pass            => 'ZMORj3Pw',
                                                  p_search_base     => 'OU=Abteilungen,DC=netcologne,DC=intern',
                                                  p_search_filter   => 'cn=' || apex_escape.ldap_search_filter(pi_vc_role),
                                                  p_attribute_names => 'distinguishedName'
                                              )) --herausfinden des genaueren Namens, benoetigt fuer die Nested Group Suche
                                      ))--*/
                                      ,
                        p_attribute_names => 'sAMAccountName'
                    ) )
            )
        where
            upper(val) = upper(pi_vc_user); --Filter auf das NamenskÃ¼rzel einer Person

        return n_count; --sollte nur 1 oder 0 ausgeben, 
    end is_user_in_role_nested;

  -------------------------------------------------------------------------------------------------------------------------------
  --
  -- Prozesse
  --
  -------------------------------------------------------------------------------------------------------------------------------

    function fkt_get_proz_befuellungsgrad (
        pi_n_pro_lfd_nr number
    ) return tpprozbefuellungsgrad
        pipelined
    as
        outdata tprozbefuellungsgradrecord;
    begin
        select
            pbf_lfd_nr,
            beg_lfd_nr,
            pro_lfd_nr,
            pbf_kommentar
        into
            outdata.pbf_lfd_nr,
            outdata.beg_lfd_nr,
            outdata.pro_lfd_nr,
            outdata.pbf_kommentar
        from
            awh_eudsgvo_proz_bef
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_befuellungsgrad;

    procedure prc_set_proz_befuellungsgrad (
        pi_n_pro_lfd_nr     number,
        pi_n_beg_lfd_nr     number,
        pi_vc_pbf_kommentar varchar2
    ) as
    begin
        merge into awh_eudsgvo_proz_bef dest
        using (
            select
                pi_n_pro_lfd_nr     as pro_lfd_nr,
                pi_n_beg_lfd_nr     as beg_lfd_nr,
                pi_vc_pbf_kommentar as pbf_kommentar
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.beg_lfd_nr = src.beg_lfd_nr,
            dest.pbf_kommentar = src.pbf_kommentar
        when not matched then
        insert (
            pro_lfd_nr,
            beg_lfd_nr,
            pbf_kommentar )
        values
            ( src.pro_lfd_nr,
              src.beg_lfd_nr,
              src.pbf_kommentar );

    end prc_set_proz_befuellungsgrad;

    function fkt_get_proz_befuellungsbeu (
        pi_n_pro_lfd_nr number
    ) return tpprozerhebungbeurteilung
        pipelined
    as
        outdata tprozerhbeurteilungrecord;
    begin
        select
            pkb_lfd_nr,
            pro_lfd_nr,
            ebu_lfd_nr_kap_alg,
            ebu_lfd_nr_kap_1,
            ebu_lfd_nr_kap_2,
            ebu_lfd_nr_kap_3,
            ebu_lfd_nr_kap_4,
            ebu_lfd_nr_kap_5,
            ebu_lfd_nr_kap_6,
            ebu_lfd_nr_kap_7,
            ebu_lfd_nr_kap_8,
            ebu_lfd_nr_kap_9
        into
            outdata.pkb_lfd_nr,
            outdata.pro_lfd_nr,
            outdata.ebu_lfd_nr_kap_alg,
            outdata.ebu_lfd_nr_kap_1,
            outdata.ebu_lfd_nr_kap_2,
            outdata.ebu_lfd_nr_kap_3,
            outdata.ebu_lfd_nr_kap_4,
            outdata.ebu_lfd_nr_kap_5,
            outdata.ebu_lfd_nr_kap_6,
            outdata.ebu_lfd_nr_kap_7,
            outdata.ebu_lfd_nr_kap_8,
            outdata.ebu_lfd_nr_kap_9
        from
            awh_proz_erhb_kap_beurt
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_befuellungsbeu;

    procedure prc_set_proz_bef_beu (
        pi_n_pro_lfd_nr number,
        pi_n_kapitel    number,
        pi_n_ebu_lfd_nr number
    ) as
    begin
        if pi_n_kapitel = 0 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_alg = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_alg )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 1 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_1 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_1 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 2 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_2 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_2 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 3 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_3 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_3 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 4 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_4 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_4 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 5 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_5 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_5 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 6 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_6 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_6 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 7 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_7 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_7 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 8 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_8 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_8 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

        if pi_n_kapitel = 9 then
            merge into awh_proz_erhb_kap_beurt dest
            using (
                select
                    pi_n_pro_lfd_nr as pro_lfd_nr,
                    pi_n_ebu_lfd_nr as ebu_lfd_nr
                from
                    dual
            ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
            when matched then update
            set dest.ebu_lfd_nr_kap_9 = src.ebu_lfd_nr
            when not matched then
            insert (
                pro_lfd_nr,
                ebu_lfd_nr_kap_9 )
            values
                ( src.pro_lfd_nr,
                  src.ebu_lfd_nr );

        end if;

    end prc_set_proz_bef_beu;

    function fkt_proz_save_allowed (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    ) return number as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_proz_erhb_lock
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        if n_count > 0 then
            select
                count(1)
            into n_count
            from
                awh_proz_erhb_lock
            where
                    pro_lfd_nr = pi_n_pro_lfd_nr
                and plo_user = pi_vc_user;

            if n_count > 0 then
                return 1;
            else
                return 0;
            end if;
        else
            return 0;
        end if;

    end fkt_proz_save_allowed;

    function fkt_proz_lock_allowed (
        pi_n_pro_lfd_nr number
    ) return number as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_proz_erhb_lock
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        if n_count = 0 then
            return 1;
        else
            return 0;
        end if;
    end fkt_proz_lock_allowed;

    procedure prc_proz_set_lock (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    ) as
        n_count number;
    begin
        select
            count(1)
        into n_count
        from
            awh_proz_erhb_lock
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        if n_count = 0 then
            insert into awh_proz_erhb_lock (
                pro_lfd_nr,
                plo_user,
                plo_timestamp
            ) values ( pi_n_pro_lfd_nr,
                       pi_vc_user,
                       sysdate );

        else
            raise_application_error(-20010, 'Der Prozess ist bereits ausgecheckt.');
        end if;

    end prc_proz_set_lock;

    procedure prc_proz_reset_lock (
        pi_n_pro_lfd_nr number,
        pi_vc_user      varchar2
    ) as
    begin
        delete from awh_proz_erhb_lock
        where
                pro_lfd_nr = pi_n_pro_lfd_nr
            and plo_user = pi_vc_user;

    end prc_proz_reset_lock;

    function fkt_get_proz_erhebungsbogen (
        pi_n_pro_lfd_nr number
    ) return tpprozerhebungsbogen
        pipelined
    as
        outdata tprozerhebungsbogenrecord;
    begin
        select
            awh_proz_erheb.pro_lfd_nr,
            awh_proz_erheb.ape_lfd_nr,
            awh_tab_prozess.pro_name,
            awh_proz_erheb.ape_timestamp
        into
            outdata.pro_lfd_nr,
            outdata.ape_lfd_nr,
            outdata.pro_name,
            outdata.ape_timestamp
        from
                 awh_proz_erheb
            inner join awh_tab_prozess on awh_tab_prozess.pro_lfd_nr = awh_proz_erheb.pro_lfd_nr
        where
            awh_proz_erheb.pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.  END FKT_GET_PROZ_ERHEBUNGSBOGEN;
    end fkt_get_proz_erhebungsbogen;

    procedure prc_set_proz_erhebungsbogen (
        pi_n_pro_lfd_nr number,
        pi_vc_ape_user  varchar2
    ) as
    begin
        merge into awh_proz_erheb dest
        using (
            select
                pi_n_pro_lfd_nr as pro_lfd_nr,
                pi_vc_ape_user  as ape_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ape_user = src.ape_user
        when not matched then
        insert (
            pro_lfd_nr,
            ape_user )
        values
            ( src.pro_lfd_nr,
              src.ape_user );

    end prc_set_proz_erhebungsbogen;

    function fkt_get_proz_erheb_1 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb1
        pipelined
    as
        outdata tprozerheb1record;
    begin
        select
            pro_lfd_nr,
            ap1_verant_stelle,
            per_lfd_nr_ges_ver,
            per_lfd_nr_vertr,
            per_lfd_nr_ds
        into
            outdata.pro_lfd_nr,
            outdata.ap1_verant_stelle,
            outdata.per_lfd_nr_ges_ver,
            outdata.per_lfd_nr_vertr,
            outdata.per_lfd_nr_ds
        from
            awh_proz_erheb_1
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_erheb_1;

    procedure prc_set_proz_erheb_1 (
        pi_n_pro_lfd_nr         number,
        pi_vc_ap1_verant_stelle varchar2,
        pi_n_per_lfd_nr_ges_ver varchar2,
        pi_n_per_lfd_nr_vertr   varchar2,
        pi_n_per_lfd_nr_ds      varchar2,
        pi_vc_ap1_user          varchar2
    ) as
    begin
        merge into awh_proz_erheb_1 dest
        using (
            select
                pi_n_pro_lfd_nr         as pro_lfd_nr,
                pi_vc_ap1_verant_stelle as ap1_verant_stelle,
                pi_n_per_lfd_nr_ges_ver as per_lfd_nr_ges_ver,
                pi_n_per_lfd_nr_vertr   as per_lfd_nr_vertr,
                pi_n_per_lfd_nr_ds      as per_lfd_nr_ds,
                pi_vc_ap1_user          as ap1_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ap1_verant_stelle = src.ap1_verant_stelle,
            dest.per_lfd_nr_ges_ver = src.per_lfd_nr_ges_ver,
            dest.per_lfd_nr_vertr = src.per_lfd_nr_vertr,
            dest.per_lfd_nr_ds = src.per_lfd_nr_ds,
            dest.ap1_user = src.ap1_user
        when not matched then
        insert (
            pro_lfd_nr,
            ap1_verant_stelle,
            per_lfd_nr_ges_ver,
            per_lfd_nr_vertr,
            per_lfd_nr_ds,
            ap1_user )
        values
            ( src.pro_lfd_nr,
              src.ap1_verant_stelle,
              src.per_lfd_nr_ges_ver,
              src.per_lfd_nr_vertr,
              src.per_lfd_nr_ds,
              src.ap1_user );

    end prc_set_proz_erheb_1;

    function fkt_get_proz_erheb_2 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb2
        pipelined
    as
        outdata tprozerheb2record;
    begin
        select
            pro_lfd_nr,
            ap2_verarb_taet,
            ap2_proz_ebene,
            ap2_dat_einf,
            ap2_ueber_gp,
            per_lfd_nr_verant_ap,
            per_lfd_nr_verant_fuehr
        into
            outdata.pro_lfd_nr,
            outdata.ap2_verarb_taet,
            outdata.ap2_proz_ebene,
            outdata.ap2_dat_einf,
            outdata.ap2_ueber_gp,
            outdata.per_lfd_nr_verant_ap,
            outdata.per_lfd_nr_verant_fuehr
        from
            awh_proz_erheb_2
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_erheb_2;

    procedure prc_set_proz_erheb_2 (
        pi_n_pro_lfd_nr              number,
        pi_vc_ap2_verarb_taet        varchar2,
        pi_vc_ap2_proz_ebene         varchar2,
        pi_dt_ap2_dat_einf           date,
        pi_vc_ap2_ueber_gp           varchar2,
        pi_n_per_lfd_nr_verant_ap    varchar2,
        pi_n_per_lfd_nr_verant_fuehr varchar2,
        pi_vc_ap2_user               varchar2
    ) as
    begin
        merge into awh_proz_erheb_2 dest
        using (
            select
                pi_n_pro_lfd_nr              as pro_lfd_nr,
                pi_vc_ap2_verarb_taet        as ap2_verarb_taet,
                pi_vc_ap2_proz_ebene         as ap2_proz_ebene,
                pi_dt_ap2_dat_einf           as ap2_dat_einf,
                pi_vc_ap2_ueber_gp           as ap2_ueber_gp,
                pi_n_per_lfd_nr_verant_ap    as per_lfd_nr_verant_ap,
                pi_n_per_lfd_nr_verant_fuehr as per_lfd_nr_verant_fuehr,
                pi_vc_ap2_user               as ap2_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ap2_verarb_taet = src.ap2_verarb_taet,
            dest.ap2_proz_ebene = src.ap2_proz_ebene,
            dest.ap2_dat_einf = src.ap2_dat_einf,
            dest.ap2_ueber_gp = src.ap2_ueber_gp,
            dest.per_lfd_nr_verant_ap = src.per_lfd_nr_verant_ap,
            dest.per_lfd_nr_verant_fuehr = src.per_lfd_nr_verant_fuehr,
            dest.ap2_user = src.ap2_user
        when not matched then
        insert (
            pro_lfd_nr,
            ap2_verarb_taet,
            ap2_proz_ebene,
            ap2_dat_einf,
            ap2_ueber_gp,
            per_lfd_nr_verant_ap,
            per_lfd_nr_verant_fuehr,
            ap2_user )
        values
            ( src.pro_lfd_nr,
              src.ap2_verarb_taet,
              src.ap2_proz_ebene,
              src.ap2_dat_einf,
              src.ap2_ueber_gp,
              src.per_lfd_nr_verant_ap,
              src.per_lfd_nr_verant_fuehr,
              src.ap2_user );

    end prc_set_proz_erheb_2;

    function fkt_get_proz_erheb_3 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb3
        pipelined
    as
        outdata tprozerheb3record;
    begin
        select
            pro_lfd_nr,
            ap3_zweckbestimmung,
            ap3_vertrag_erbringung,
            ap3_besch_verh,
            ap3_einkaufsvertrag,
            ap3_beratervertrag,
            ap3_sonstiges,
            ap3_verarb_vorvertrag_mass,
            ap3_verarb_recht_ver,
            ap3_verarb_wahrn_auf,
            ap3_verarb_berech_int,
            ap3_einwill_verarb,
            ap3_einwill_nachweise,
            ap3_sonstige,
            ap3_risiko
        into
            outdata.pro_lfd_nr,
            outdata.ap3_zweckbestimmung,
            outdata.ap3_vertrag_erbringung,
            outdata.ap3_besch_verh,
            outdata.ap3_einkaufsvertrag,
            outdata.ap3_beratervertrag,
            outdata.ap3_sonstiges,
            outdata.ap3_verarb_vorvertrag_mass,
            outdata.ap3_verarb_recht_ver,
            outdata.ap3_verarb_wahrn_auf,
            outdata.ap3_verarb_berech_int,
            outdata.ap3_einwill_verarb,
            outdata.ap3_einwill_nachweise,
            outdata.ap3_sonstige,
            outdata.ap3_risiko
        from
            awh_proz_erheb_3
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_erheb_3;

    procedure prc_set_proz_erheb_3 (
        pi_n_pro_lfd_nr               number,
        pi_vc_ap3_zweckbestimmung     varchar2,
        pi_n_ap3_vertrag_erbringung   number,
        pi_n_ap3_besch_verh           number,
        pi_n_ap3_einkaufsvertrag      number,
        pi_n_ap3_beratervertrag       number,
        pi_vc_ap3_sonstiges           varchar2,
        pi_vc_ap3_verarb_vorvert_mass varchar2,
        pi_vc_ap3_verarb_recht_ver    varchar2,
        pi_vc_ap3_verarb_wahrn_auf    varchar2,
        pi_vc_ap3_verarb_berech_int   varchar2,
        pi_vc_ap3_einwill_verarb      varchar2,
        pi_n_ap3_einwill_nachweise    number,
        pi_vc_ap3_sonstige            varchar2,
        pi_n_ap3_risiko               number,
        pi_vc_ap3_user                varchar2
    ) as
    begin
        merge into awh_proz_erheb_3 dest
        using (
            select
                pi_n_pro_lfd_nr               as pro_lfd_nr,
                pi_vc_ap3_zweckbestimmung     as ap3_zweckbestimmung,
                pi_n_ap3_vertrag_erbringung   as ap3_vertrag_erbringung,
                pi_n_ap3_besch_verh           as ap3_besch_verh,
                pi_n_ap3_einkaufsvertrag      as ap3_einkaufsvertrag,
                pi_n_ap3_beratervertrag       as ap3_beratervertrag,
                pi_vc_ap3_sonstiges           as ap3_sonstiges,
                pi_vc_ap3_verarb_vorvert_mass as ap3_verarb_vorvertrag_mass,
                pi_vc_ap3_verarb_recht_ver    as ap3_verarb_recht_ver,
                pi_vc_ap3_verarb_wahrn_auf    as ap3_verarb_wahrn_auf,
                pi_vc_ap3_verarb_berech_int   as ap3_verarb_berech_int,
                pi_vc_ap3_einwill_verarb      as ap3_einwill_verarb,
                pi_n_ap3_einwill_nachweise    as ap3_einwill_nachweise,
                pi_vc_ap3_sonstige            as ap3_sonstige,
                pi_n_ap3_risiko               as ap3_risiko,
                pi_vc_ap3_user                as ap3_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ap3_vertrag_erbringung = src.ap3_vertrag_erbringung,
            dest.ap3_besch_verh = src.ap3_besch_verh,
            dest.ap3_einkaufsvertrag = src.ap3_einkaufsvertrag,
            dest.ap3_beratervertrag = src.ap3_beratervertrag,
            dest.ap3_sonstiges = src.ap3_sonstiges,
            dest.ap3_verarb_vorvertrag_mass = src.ap3_verarb_vorvertrag_mass,
            dest.ap3_verarb_recht_ver = src.ap3_verarb_recht_ver,
            dest.ap3_verarb_wahrn_auf = src.ap3_verarb_wahrn_auf,
            dest.ap3_verarb_berech_int = src.ap3_verarb_berech_int,
            dest.ap3_einwill_verarb = src.ap3_einwill_verarb,
            dest.ap3_einwill_nachweise = src.ap3_einwill_nachweise,
            dest.ap3_sonstige = src.ap3_sonstige,
            dest.ap3_risiko = src.ap3_risiko,
            dest.ap3_user = src.ap3_user
        when not matched then
        insert (
            pro_lfd_nr,
            ap3_vertrag_erbringung,
            ap3_besch_verh,
            ap3_einkaufsvertrag,
            ap3_beratervertrag,
            ap3_sonstiges,
            ap3_verarb_vorvertrag_mass,
            ap3_verarb_recht_ver,
            ap3_verarb_wahrn_auf,
            ap3_verarb_berech_int,
            ap3_einwill_verarb,
            ap3_einwill_nachweise,
            ap3_sonstige,
            ap3_risiko,
            ap3_user )
        values
            ( src.pro_lfd_nr,
              src.ap3_vertrag_erbringung,
              src.ap3_besch_verh,
              src.ap3_einkaufsvertrag,
              src.ap3_beratervertrag,
              src.ap3_sonstiges,
              src.ap3_verarb_vorvertrag_mass,
              src.ap3_verarb_recht_ver,
              src.ap3_verarb_wahrn_auf,
              src.ap3_verarb_berech_int,
              src.ap3_einwill_verarb,
              src.ap3_einwill_nachweise,
              src.ap3_sonstige,
              src.ap3_risiko,
              src.ap3_user );

    end prc_set_proz_erheb_3;

    function fkt_get_proz_erheb_8 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb8
        pipelined
    as
        outdata tprozerheb8record;
    begin
        select
            pro_lfd_nr,
            ap8_aufbewahrung,
            ap8_lf_95,
            ap8_lf_loeschkon,
            ap8_lf_sonst
        into
            outdata.pro_lfd_nr,
            outdata.ap8_aufbewahrung,
            outdata.ap8_lf_95,
            outdata.ap8_lf_loeschkon,
            outdata.ap8_lf_sonst
        from
            awh_proz_erheb_8
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_erheb_8;

    procedure prc_set_proz_erheb_8 (
        pi_n_pro_lfd_nr        number,
        pi_vc_ap8_aufbewahrung varchar2,
        pi_n_ap8_lf_95         number,
        pi_n_ap8_lf_loeschkon  number,
        pi_vc_ap8_lf_sonst     varchar2,
        pi_vc_ap8_user         varchar2
    ) as
    begin
        merge into awh_proz_erheb_8 dest
        using (
            select
                pi_n_pro_lfd_nr        as pro_lfd_nr,
                pi_vc_ap8_aufbewahrung as ap8_aufbewahrung,
                pi_n_ap8_lf_95         as ap8_lf_95,
                pi_n_ap8_lf_loeschkon  as ap8_lf_loeschkon,
                pi_vc_ap8_lf_sonst     as ap8_lf_sonst,
                pi_vc_ap8_user         as ap8_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ap8_aufbewahrung = src.ap8_aufbewahrung,
            dest.ap8_lf_95 = src.ap8_lf_95,
            dest.ap8_lf_loeschkon = src.ap8_lf_loeschkon,
            dest.ap8_lf_sonst = src.ap8_lf_sonst,
            dest.ap8_user = src.ap8_user
        when not matched then
        insert (
            pro_lfd_nr,
            ap8_aufbewahrung,
            ap8_lf_95,
            ap8_lf_loeschkon,
            ap8_lf_sonst,
            ap8_user )
        values
            ( src.pro_lfd_nr,
              src.ap8_aufbewahrung,
              src.ap8_lf_95,
              src.ap8_lf_loeschkon,
              src.ap8_lf_sonst,
              src.ap8_user );

    end prc_set_proz_erheb_8;

    function fkt_get_proz_erheb_10 (
        pi_n_pro_lfd_nr number
    ) return tpprozerheb10
        pipelined
    as
        outdata tprozerheb10record;
    begin
        select
            pro_lfd_nr,
            ap10_verw_tom,
            ap10_verf_reg_ueb,
            ap10_datenschutzanw,
            ap10_sonst
        into
            outdata.pro_lfd_nr,
            outdata.ap10_verw_tom,
            outdata.ap10_verf_reg_ueb,
            outdata.ap10_datenschutzanw,
            outdata.ap10_sonst
        from
            awh_proz_erheb_10
        where
            pro_lfd_nr = pi_n_pro_lfd_nr;

        pipe row ( outdata );
        return;
    exception
        when no_data_found then
            return; --diese Behandlung ist ausreichend, weil im Ergebnis keine Zeile geliefert werden soll.
    end fkt_get_proz_erheb_10;

    procedure prc_set_proz_erheb_10 (
        pi_n_pro_lfd_nr          number,
        pi_n_ap10_verw_tom       number,
        pi_n_ap10_verf_reg_ueb   number,
        pi_n_ap10_datenschutzanw number,
        pi_vc_ap10_sonst         varchar2,
        pi_vc_ap10_user          varchar2
    ) as
    begin
        merge into awh_proz_erheb_10 dest
        using (
            select
                pi_n_pro_lfd_nr          as pro_lfd_nr,
                pi_n_ap10_verw_tom       as ap10_verw_tom,
                pi_n_ap10_verf_reg_ueb   as ap10_verf_reg_ueb,
                pi_n_ap10_datenschutzanw as ap10_datenschutzanw,
                pi_vc_ap10_sonst         as ap10_sonst,
                pi_vc_ap10_user          as ap10_user
            from
                dual
        ) src on ( src.pro_lfd_nr = dest.pro_lfd_nr )
        when matched then update
        set dest.ap10_verw_tom = src.ap10_verw_tom,
            dest.ap10_verf_reg_ueb = src.ap10_verf_reg_ueb,
            dest.ap10_datenschutzanw = src.ap10_datenschutzanw,
            dest.ap10_sonst = src.ap10_sonst,
            dest.ap10_user = src.ap10_user
        when not matched then
        insert (
            pro_lfd_nr,
            ap10_verw_tom,
            ap10_verf_reg_ueb,
            ap10_datenschutzanw,
            ap10_sonst,
            ap10_user )
        values
            ( src.pro_lfd_nr,
              src.ap10_verw_tom,
              src.ap10_verf_reg_ueb,
              src.ap10_datenschutzanw,
              src.ap10_sonst,
              src.ap10_user );

    end prc_set_proz_erheb_10;

    procedure prc_insert_in_awh_mtn_sys_vm (
        pi_asy_lfd_nr   number,
        pi_vm_uid       number,
        pi_sv_user      varchar2,
        sv_sv_timestamp date
    ) as
    begin
        insert into awh_mtn_sys_vm (
            sv_uid,
            asy_lfd_nr,
            vm_uid,
            sv_user,
            sv_timestamp
        ) values ( to_number(sys_guid(), 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'),
                   pi_asy_lfd_nr,
                   pi_vm_uid,
                   pi_sv_user,
                   sysdate );

    end prc_insert_in_awh_mtn_sys_vm;

    procedure prc_delete_in_awh_mtn_sys_vm (
        pi_vm_uid number
    ) as
    begin
        delete from awh_mtn_sys_vm
        where
            vm_uid = pi_vm_uid;

    end prc_delete_in_awh_mtn_sys_vm;

    procedure prc_set_system_attribute (
        pi_asy_lfd_nr     number,
        pi_dat_bea_uid_fk number,
        pi_dat_kor_uid_fk number,
        pi_ges_uid_fk     number
    ) as
    begin
        merge into awh_system_attribute dest
        using (
            select
                pi_asy_lfd_nr     as asy_lfd_nr,
                pi_dat_bea_uid_fk as dat_bea_uid_fk,
                pi_dat_kor_uid_fk as dat_kor_uid_fk,
                pi_ges_uid_fk     as ges_uid_fk
            from
                dual
        ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
        when matched then update
        set dest.dat_bea_uid_fk = src.dat_bea_uid_fk,
            dest.dat_kor_uid_fk = src.dat_kor_uid_fk,
            dest.ges_uid_fk = src.ges_uid_fk
        when not matched then
        insert (
            asy_lfd_nr,
            dat_bea_uid_fk,
            dat_kor_uid_fk,
            ges_uid_fk )
        values
            ( src.asy_lfd_nr,
              src.dat_bea_uid_fk,
              src.dat_kor_uid_fk,
              src.ges_uid_fk );

    end prc_set_system_attribute;

    procedure merge_awh_system_attribute (
        p_asy_lfd_nr        in number,
        p_dat_bea_uid_fk    in number default null,
        p_dat_kor_uid_fk    in number default null,
        p_ges_uid_fk        in number default null,
        p_avv_abgeschlossen in number default null
    ) as
    begin
        merge into awh_system_attribute target
        using (
            select
                p_asy_lfd_nr        as asy_lfd_nr,
                p_dat_bea_uid_fk    as dat_bea_uid_fk,
                p_dat_kor_uid_fk    as dat_kor_uid_fk,
                p_ges_uid_fk        as ges_uid_fk,
                p_avv_abgeschlossen as avv_abgeschlossen
            from
                dual
        ) src on ( target.asy_lfd_nr = src.asy_lfd_nr )
        when matched then update
        set target.dat_bea_uid_fk = nvl(p_dat_bea_uid_fk, target.dat_bea_uid_fk),
            target.dat_kor_uid_fk = nvl(p_dat_kor_uid_fk, target.dat_kor_uid_fk),
            target.ges_uid_fk = nvl(p_ges_uid_fk, target.ges_uid_fk),
            target.avv_abgeschlossen = nvl(p_avv_abgeschlossen, target.avv_abgeschlossen)
        when not matched then
        insert (
            asy_lfd_nr,
            dat_bea_uid_fk,
            dat_kor_uid_fk,
            ges_uid_fk,
            avv_abgeschlossen )
        values
            ( p_asy_lfd_nr,
              p_dat_bea_uid_fk,
              p_dat_kor_uid_fk,
              p_ges_uid_fk,
              p_avv_abgeschlossen );

    end merge_awh_system_attribute;

end pck_anwhandbuch;
/


-- sqlcl_snapshot {"hash":"8dbe8e3e690585ee26e193e03250797a724ccb32","type":"PACKAGE_BODY","name":"PCK_ANWHANDBUCH","schemaName":"AWH_MAIN","sxml":""}