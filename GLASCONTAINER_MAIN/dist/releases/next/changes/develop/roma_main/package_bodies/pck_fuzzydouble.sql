-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480977472 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_fuzzydouble.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_fuzzydouble.sql:null:d2d327ebcec7a61f036b1aa452ad4e3e64c6e6ad:create

create or replace package body roma_main.pck_fuzzydouble as
/**
 * Hilfsroutinen zum Abfragen und Auswerten der Fuzzy Double Dublettensuche
 * sowie der Dublettensuche im Glascontainer 
 *
 * @ticket FTTH-531
 * @url    https://jira.netcologne.intern/browse/FTTH-531
 * @author WISAND  Andreas Wismann <wismann@when-others.com>
 * @AP     Thorsten Westenberg (Fuzzy-Suche in Siebel)
 * @AP     Tino Götting, Andreas Kunze (Fuzzy-Server)
 *
 * @creation 2022-12
 */
    body_version            constant varchar2(30) := '2024-06-26 0830';
    g_ignore_service_errors boolean; -- init: NULL, damit werden Fehler nicht ignoriert
  
  ------------------------------------------------------------------------------
  /* //// Fehler-Check am 2023-08-09 zeigt eine Häufung von 
  "10702 Cannot reach ncvhalp:40103 ORA-06512: at "ROMA_MAIN.PCK_FUZZYDOUBLE", line 702"
  bei den täglichen (nächtlichen) Abfragen:
  
select * from logs where log_id > 31098918
   and routine_name like 'PCK_FUZZYDOUBLE%';  
  */
  
  
  ------------------------------------------------------------------------------
  -- Exceptions:
  -- Insbesondere in der Entwicklungsumgebung tritt teilweise der Fehler auf, 
  -- dass die Fuzzy-Suche nicht erreichbar ist:
  -- ORA-10702 Cannot reach ncvservicet:40003  
    e_service_not_reachable exception;
    pragma exception_init ( e_service_not_reachable, -10702 );
  ------------------------------------------------------------------------------

    c_fuzzydouble_url       constant t_url :=
        case substr(pck_env.fv_db_name, 1, 4)
        -- durch Auswertung nur der ersten vier Buchstaben spielen Nummern-Postfixes keine Rolle
        -- (NMCE3 = NMCE, NMCX3 = NMCX usw.)
            when 'NMC' then
                'http://NCvHALp.netcologne.intern:81/fuzzy.double.server/services/FuzzyDoubleService' -- 2023-03-02 Thorsten Westenberg: PROD
            when 'NMCX' then
                'http://ncvhalx.netcologne.intern:81/fuzzy.double.server/services/FuzzyDoubleService' -- aus dem Ticket (nur ein Produktionsabzug, nicht für PROD geeignet)
            when 'NMCU' then
                'http://NCvHALe.netcologne.intern:82/fuzzy.double.server/services/FuzzyDoubleService'
            when 'NMCS' then
                'http://NCvHALx.netcologne.intern:82/fuzzy.double.server/services/FuzzyDoubleService'
            when 'NMCE' then
                'http://NCvHALe.netcologne.intern:84/fuzzy.double.server/services/FuzzyDoubleService'
      --ELSE -- muss auf einen Fehler laufen! In anderen Umgebungen als den genannten ist die URL für eine Fuzzy-Suche nicht definiert
        end;
    c_fuzzydouble_namespace constant varchar2(60) := 'xmlns:ns2="http://fuzzydouble.service.netcologne.de/"';
    xml_declaration         constant varchar2(60) := q'|<?xml version="1.0" encoding="UTF-8"?>|' || chr(10);
  
  -- Beginn jedes SOAP-Requests an den Fuzzydouble-Server:
    c_soap_request_start    constant varchar2(1000) := xml_declaration || '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:fuz="http://fuzzydouble.service.netcologne.de/">
   <soapenv:Header/>
   <soapenv:Body>';
  
  -- Abschluss jedes SOAP-Requests an den Fuzzydouble-Server:
    c_soap_request_end      constant varchar2(1000) := '
     </soapenv:Body>
</soapenv:Envelope>';
  
  
  
 /**
  * Setzt den Wert für die Package-Variable G_IGNORE_SERVICE_ERRORS.
  *
  * @param pib_setting  [IN ]  TRUE|FALSE. Wenn TRUE, führen Netzwerk-Exceptions an der Fuzzy-Serviceschnittstelle
  *                            zu keiner Exception, sondern verhalten sich wie eine leere Ergebismenge.
  *                            (kann beispielsweise in DEV sinnvoll sein, um im Grid weiter entwickeln zu können)
  */
    procedure ignore_service_errors (
        pib_setting in boolean
    ) is
    begin
        g_ignore_service_errors := pib_setting;
    end;
  
  
  /**
  * Formatiert jeden Routinen-Namen mit dem Prefix des Packages, damit in den LOGS
  * die Suche nach dem Package-Namen im Fehlerfall einfacher wird
  *
  * @example
  * SELECT * FROM LOGS WHERE ROUTINE_NAME LIKE 'PCK_GLASCONTAINER%' AND ...
  */
    function qualified_name (
        i_routine_name in varchar2
    ) return varchar2
        deterministic
    is
    begin
        return $$plsql_unit
               || '.'
               || upper(i_routine_name);
    end;  
  
/**
 * Gibt den Versionsstring des Package Bodies zurück
 */
    function get_body_version return varchar2
        deterministic
    is
    begin
        return body_version;
    end;  
  
-- @url https://docs.oracle.com/en/database/oracle/application-express/21.1/aeapi/Invoking-a-SOAP-Style-Web-Service.html#GUID-172535D9-552E-4403-BE79-2EE92DB4AFCE  
-- view-source:http://ncvhalx.netcologne.intern:82/fuzzy.double.server/services/FuzzyDoubleService?WSDL
/**
 * Gibt den kompletten ungeparsten Antwortbaum 'doubletCheckBank' zurück
 * (Dublettensuche in Siebel über Kontoverbindung)
 *
 * @param piv_iban        IBAN der Kontoverbindung, zu der Übereinstimmungen gesucht werden
 * @param piv_kontonummer (optional) Kontonummer nach altem Muster, bevor es IBAN gab
 * @param piv_bic         (optional) Bank Identifier Code (BIC)
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * select pck_fuzzydouble.fx_doublet_check_bank(piv_iban => 'DE77301602130000827010') from dual; -- keine Dublette
 * select pck_fuzzydouble.fx_doublet_check_bank(piv_iban => 'DE02370501980001802057') from dual; -- viele Dubletten
 *
 */
    function fx_doublet_check_bank (
        piv_iban        in varchar2,
        piv_kontonummer in varchar2 default null,
        piv_bic         in varchar2 default null
    ) return xmltype is

        v_request       t_request;
        v_response      xmltype;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fx_doublet_check_bank';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('piv_kontonummer', piv_kontonummer);
            pck_format.p_add('piv_bic', piv_bic);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    begin
        v_request := c_soap_request_start
                     || '
      <fuz:FDDoubletCheckBankRequestWrapper>
         <FDDoubletCheckBankRequest>
            <BankAccountNr>'
                     || piv_kontonummer
                     || '</BankAccountNr>
            <BankIdentificationCode>'
                     || piv_bic
                     || '</BankIdentificationCode>
            <BankIBAN>'
                     || piv_iban
                     || '</BankIBAN>
         </FDDoubletCheckBankRequest>
      </fuz:FDDoubletCheckBankRequestWrapper>
'
                     || c_soap_request_end;

        v_response := apex_web_service.make_request(
            p_url      => c_fuzzydouble_url,
            p_action   => null --- Angabe 'doubletCheckBank' ist nicht nötig
            ,
            p_envelope => v_request
        );
/* typische Antworten:
1. Keine Überstimmungen gefunden:
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <ns2:FDDoubletCheckBankResponseWrapper xmlns:ns2="http://fuzzydouble.service.netcologne.de/">
            <FDSearchResponse>
                <FDResult>
                    <InternalErrorCode>200</InternalErrorCode>
                    <InternalErrorText>OK</InternalErrorText>
                    <ListOverflow>0</ListOverflow>
                    <MatchCount>0</MatchCount>
                    <MatchesList/>
                </FDResult>
            </FDSearchResponse>
        </ns2:FDDoubletCheckBankResponseWrapper>
    </soap:Body>
</soap:Envelope>
2. Übereinstimmungen gefunden:
<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <ns2:FDDoubletCheckBankResponseWrapper xmlns:ns2="http://fuzzydouble.service.netcologne.de/">
      <FDSearchResponse>
        <FDResult>
          <InternalErrorCode>200</InternalErrorCode>
          <InternalErrorText>OK</InternalErrorText>
          <ListOverflow>-1</ListOverflow>
          <MatchCount>50</MatchCount>
          <MatchesList>
            <Record rowId="1-1B03V7T" ruleNumber="2" score="100">
              <Firstname score="-1">joana</Firstname>
              <Lastname score="-1">landsberg</Lastname>
              <Birthday score="-1">19820724</Birthday>
              <Companyname score="-1">frau</Companyname>
              <Street score="-1">bahnhof_hoffnungsthal</Street>
              <HouseNr score="-1">1</HouseNr>
              <Zipcode score="-1">51503</Zipcode>
              <City score="-1">roesrath</City>
              <BankAccountNr score="-1">1802057</BankAccountNr>
              <BankIdentificationCode score="-1">37050198</BankIdentificationCode>
              <IsDoubletCheckRelevant>true</IsDoubletCheckRelevant>
              <BankIBAN score="100">DE02370501980001802057</BankIBAN>
            </Record>
            <Record rowId="1-50NZ5NE" ruleNumber="2" score="100">
              <Firstname score="-1">pawnshop</Firstname>
              <Lastname score="-1">boy</Lastname>
              <Birthday score="-1">19350201</Birthday>
              <Companyname score="-1">boy</Companyname>
              <Street score="-1">selma_lagerloef_str</Street>
              <HouseNr score="-1">40</HouseNr>
              <Zipcode score="-1">50859</Zipcode>
              <City score="-1">koeln</City>
              <BankAccountNr score="-1">1802057</BankAccountNr>
              <BankIdentificationCode score="-1">37050198</BankIdentificationCode>
              <IsDoubletCheckRelevant>true</IsDoubletCheckRelevant>
              <BankIBAN score="100">DE02370501980001802057</BankIBAN>
            </Record>
          </MatchesList>
        </FDResult>
      </FDSearchResponse>
    </ns2:FDDoubletCheckBankResponseWrapper>
  </soap:Body>
</soap:Envelope>
*/
        p_check_response_errors(
            pix_response => v_response,
            piv_xpath    => '//ns2:FDDoubletCheckBankResponseWrapper/FDSearchResponse/FDResult'
        );
        return v_response;
    exception
        when others then
            if sqlcode <> c_plausi_error_number then -- nur technische Fehler loggen:
                pck_logs.p_error(
                    pic_message      => fcl_params()
                                   || chr(10)
                                   || '<!-- Request: -->'
                                   || chr(10)
                                   || v_request
                                   || chr(10)
                                   || chr(10)
                                   || '<!-- Response: -->'
                                   || chr(10)
                                   || v_response.getstringval(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end fx_doublet_check_bank;

    function bank_liste (
        piv_iban        in varchar2,
        piv_kontonummer in varchar2 default null,
        piv_bic         in varchar2 default null
    ) return t_fuzzy_persons
        pipelined
    is
    begin
        raise_application_error(c_plausi_error_number, 'Bitte anstatt BANK_LISTE zukünftig FT_DOUBLET_CHECK_BANK verwenden (diese Funktion wurde umbenannt)'
        );
    end;
  
/**
 * Table Function: 
 * Gibt die geparste Antwort der Dublettensuche zur Kontoverbindung
 * ("DoubletCheckBank") als SQL-Tabelle zurück
 *
 * @param piv_iban                   IBAN der Kontoverbindung, zu der Übereinstimmungen gesucht werden,
 *                                   darf keine Kleinbuchstaben oder Leerzeichen enthalten
 * @param piv_kontonummer            (optional) Kontonummer nach altem Muster, bevor es IBAN gab
 * @param piv_bic                    (optional) Bank Identifier Code (BIC)
 * @param pin_ignore_service_errors  (optional 0|1) wenn 1, werden Netzwerk-Fehler wie "leere Ergebnismenge" behandelt
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * select * from table(pck_fuzzydouble.ft_doublet_check_bank('DE77301602130000827010')); -- keine Dublette
 *
 * @example
 * select * from table(pck_fuzzydouble.ft_doublet_check_bank('DE02370501980001802057')); -- viele Dubletten
 *
 * @example
 * -- vollständige Spaltenliste:
 * SELECT ROW_ID, RULE_NUMBER, SCORE, VORNAME, NACHNAME, GEBURTSDATUM, FIRMENNAME, STRASSE, HAUSNUMMER, PLZ, ORT, IBAN, KONTONUMMER, BIC
 *   FROM TABLE(PCK_FUZZYDOUBLE.ft_doublet_check_bank('DE02370501980001802057'));
 *
 * @throws
 * Insbesondere in der Entwicklungsumgebung tritt teilweise der Fehler auf, dass die Fuzzy-Suche nicht erreichbar ist:
 * ORA-10702 Cannot reach ncvservicet:40003 
 */
    function ft_doublet_check_bank (
        piv_iban                  in varchar2,
        piv_kontonummer           in varchar2 default null,
        piv_bic                   in varchar2 default null,
        pin_ignore_service_errors in natural default null
    ) return t_fuzzy_persons
        pipelined
    is

        c_ignore_service_errors constant boolean := pin_ignore_service_errors = 1;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name         constant logs.routine_name%type := 'ft_doublet_check_bank';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_iban', piv_iban);
            pck_format.p_add('piv_kontonummer', piv_kontonummer);
            pck_format.p_add('piv_bic', piv_bic);
            pck_format.p_add('pin_ignore_service_errors', pin_ignore_service_errors);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
        g_ignore_service_errors := c_ignore_service_errors; -- um die Prüfung in p_check_response_errors auszusetzen
    -- Plausi-Prüfung der Parameter:
        if
            piv_iban is null
            and piv_kontonummer is null
            and piv_bic is null
        then
            return; -- RAISE_APPLICATION_ERROR(c_plausi_error_number, 'Duplikatcheck Bankverbindung: Kontoinformationen sind leer');
        end if;
        for matcheslist in (
            with fuzzydouble as (
                select
                    fx_doublet_check_bank(
                        piv_iban        => piv_iban,
                        piv_kontonummer => piv_kontonummer,
                        piv_bic         => piv_bic
                    ) as response
                from
                    dual
            )
            select
                row_id,
                rule_number,
                score,
                vorname,
                nachname,
                geburtsdatum,
                firmenname,
                strasse,
                hausnummer,
                plz,
                ort,
                iban,
                kontonummer,
                bic
            from
                fuzzydouble,
                xmltable ( '//*/MatchesList/Record'
                        passing fuzzydouble.response
                    columns
                        row_id varchar2(100) path '@rowId',
                        rule_number integer path '@ruleNumber',
                        score integer path '@score',
                        vorname varchar2(100) path 'Firstname',
                        nachname varchar2(100) path 'Lastname',
                        geburtsdatum varchar2(8) path 'Birthday',
                        firmenname varchar2(100) path 'Companyname' -- da steht reichlich Unfug drin
                        ,
                        strasse varchar2(100) path 'Street',
                        hausnummer varchar2(30) path 'HouseNr',
                        plz varchar2(10) path 'Zipcode',
                        ort varchar2(100) path 'City',
                        iban varchar2(100) path 'BankIBAN',
                        kontonummer varchar2(100) path 'BankAccountNr',
                        bic varchar2(30) path 'BankIdentificationCode'
                ) parsed
        ) loop
            pipe row ( new t_fuzzy_person(src_bnk, matcheslist.row_id, null -- //// @kundennummer hier hinzufügen genau wie in Zeile 1024!!!
            , matcheslist.rule_number, matcheslist.score,
                                          matcheslist.vorname, matcheslist.nachname, to_date(matcheslist.geburtsdatum, 'YYYYMMDD'), matcheslist.firmenname
                                          ,
                                          matcheslist.strasse, matcheslist.hausnummer, matcheslist.plz, matcheslist.ort, matcheslist.iban
                                          ,
                                          matcheslist.kontonummer, matcheslist.bic) );
        end loop;

        return;
    exception
        when no_data_needed then -- Pipelined Function Standardbehandlung
            return;
        when e_service_not_reachable then
            if c_ignore_service_errors then
                return;
            else
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );

                raise;
            end if;
        when others then
            if sqlcode <> c_plausi_error_number then -- nur technische Fehler loggen:
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end ft_doublet_check_bank;
  
--------------------------------------------------------------------------------
/**
 * Gibt den kompletten ungeparsten Antwortbaum 'PhoneticSearch' zurück
 * (Dublettensuche in Siebel über Namen und Adressen)
 *
 * @param piv_nachname   [IN] Nachname
 * @param piv_vorname    [IN] Vorname
 * @param piv_firmenname [IN] Firmenname
 * @param piv_strasse    [IN] Straße
 * @param piv_hausnummer [IN] Hausnummer
 * @param piv_plz        [IN] Postleitzahl
 * @param piv_ort        [IN] Ort
 *
 * @throws   Alle Exceptions werden geloggt und geworfen.
 *
 * @example
 * select pck_fuzzydouble.fx_phonetic_search(piv_nachname => 'Müller-Lüdenscheid') from dual;
 *
 */
    function fx_phonetic_search (
        piv_nachname   in varchar2,
        piv_vorname    in varchar2,
        piv_firmenname in varchar2 default null,
        piv_strasse    in varchar2 default null,
        piv_hausnummer in varchar2 default null,
        piv_plz        in varchar2 default null,
        piv_ort        in varchar2 default null
    ) return xmltype is

        v_request       t_request;
        v_response      xmltype;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'fx_phonetic_search';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_strasse', piv_strasse);
            pck_format.p_add('piv_firmenname', piv_firmenname);
            pck_format.p_add('piv_hausnummer', piv_hausnummer);
            pck_format.p_add('piv_plz', piv_plz);
            pck_format.p_add('piv_ort', piv_ort);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------    
    begin
        v_request := c_soap_request_start
                     || '
        <fuz:FDPhoneticSearchRequestWrapper>
            <FDPhoneticCheckRequest>
                <Firstname>'
                     || piv_vorname
                     || '</Firstname>
                <Lastname>'
                     || piv_nachname
                     || '</Lastname>
                <Street>'
                     || piv_strasse
                     || '</Street>'
                -- optionale Suchfelder:
                     ||
            case
                when piv_hausnummer is not null then
                    '
                <HouseNr>'
                    || piv_hausnummer
                    || '</HouseNr>'
            end
                     ||
            case
                when piv_plz is not null then
                    '
                <ZipCode>'
                    || piv_plz
                    || '</ZipCode>'
            end
                     ||
            case
                when piv_ort is not null then
                    '
                <City>'
                    || piv_ort
                    || '</City>'
            end
                     ||
            case
                when piv_firmenname is not null then
                    '
                <CompanyName>'
                    || piv_firmenname
                    || '</CompanyName>'
            end
                     || '
            </FDPhoneticCheckRequest>
        </fuz:FDPhoneticSearchRequestWrapper>
'
                     || c_soap_request_end;

        v_response := apex_web_service.make_request(
            p_url      => c_fuzzydouble_url,
            p_action   => null,
            p_envelope => v_request
        );
        
    -- typische Antwort:
    -- <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    --     <soap:Body>
    --         <ns2:FDPhoneticSearchResponseWrapper xmlns:ns2="http://fuzzydouble.service.netcologne.de/">
    --             <FDSearchResponse>
    --                 <FDResult>
    --                     <InternalErrorCode>200</InternalErrorCode>
    --                     <InternalErrorText>OK</InternalErrorText>
    --                     <ListOverflow>4</ListOverflow>
    --                     <MatchCount>4</MatchCount>
    --                     <MatchesList>
    --                         <Record rowId="account-269195739" ruleNumber="1" score="87">
    --                             <Firstname score="100">manfred</Firstname>
    --                             <Lastname score="74">stermann</Lastname>
    --                             <Birthday score="-1">19570430</Birthday>
    --                             <Companyname score="-1">frau-herr-liza-tox</Companyname>
    --                             <Street score="-1">duesseldorfer_str</Street>
    --                             <HouseNr score="-1">97</HouseNr>
    --                             <Zipcode score="-1">51379</Zipcode>
    --                             <City score="-1">leverkusen</City>
    --                             <BankAccountNr score="-1">1802057</BankAccountNr>
    --                             <BankIdentificationCode score="-1">37050198</BankIdentificationCode>
    --                             <IsDoubletCheckRelevant>true</IsDoubletCheckRelevant>
    --                             <BankIBAN score="-1">DE02370501980001802057</BankIBAN>
    --                         </Record>
    --                         <Record rowId="account-269343254" ruleNumber="1" score="87">
    --                             <Firstname score="100">manfred</Firstname>
    --                             <Lastname score="72">kistermann</Lastname>
    --                             <Birthday score="-1">19490208</Birthday>
    --                             <Companyname score="-1">blaze-frau-herr-kiyahani</Companyname>
    --                             <Street score="-1">pappelweg</Street>
    --                             <HouseNr score="-1">3</HouseNr>
    --                             <Zipcode score="-1">52080</Zipcode>
    --                             <City score="-1">aachen</City>
    --                             <BankAccountNr score="-1">1802057</BankAccountNr>
    --                             <BankIdentificationCode score="-1">37050198</BankIdentificationCode>
    --                             <IsDoubletCheckRelevant>true</IsDoubletCheckRelevant>
    --                             <BankIBAN score="-1">DE02370501980001802057</BankIBAN>
    --                         </Record>
    --                     </MatchesList>
    --                 </FDResult>
    --             </FDSearchResponse>
    --         </ns2:FDPhoneticSearchResponseWrapper>
    --     </soap:Body>
    -- </soap:Envelope> 
        p_check_response_errors(
            pix_response => v_response,
            piv_xpath    => '//ns2:FDPhoneticSearchResponseWrapper/FDSearchResponse/FDResult'
        );
        return v_response;
    exception
        when others then
            if sqlcode <> c_plausi_error_number then -- nur technische Fehler loggen:
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end fx_phonetic_search;
/**
 * Table Function: 
 * Gibt die geparste Antwort der Phonetischen Personen-Suche
 * ("Phonetic Search") als SQL-Tabelle zurück
 *
 * @param piv_nachname              [IN] Nachname
 * @param piv_vorname               [IN] Vorname
 * @param piv_firmenname            [IN] Firmenname
 * @param piv_strasse               [IN] Straße
 * @param piv_hausnummer            [IN] Hausnummer
 * @param piv_plz                   [IN] Postleitzahl
 * @param piv_ort                   [IN] Ort
 * @param pin_ignore_service_errors [IN] (optional 0|1) wenn 1, werden Netzwerk-Fehler wie "leere Ergebnismenge" behandelt 
 * 
 *
 * @usage    Es dürfen nicht alle Parameter zugleich leer sein
 *
 * @throws   User Defined Exception: wenn alle Parameter leer sind.
 *           Alle anderen Exceptions werden geloggt und geworfen.
 *
 * @example
 * -- vollständige Spaltenliste:
 * SELECT ROW_ID, RULE_NUMBER, SCORE, VORNAME, NACHNAME, GEBURTSDATUM, FIRMENNAME, STRASSE, HAUSNUMMER, PLZ, ORT, IBAN, KONTONUMMER, BIC
 *   FROM TABLE(pck_fuzzydouble.ft_phonetic_search(
 * 'Mustermann', 'Erika'
 * ));
 *
 * @throws
 * Insbesondere in der Entwicklungsumgebung tritt teilweise der Fehler auf, dass die Fuzzy-Suche nicht erreichbar ist:
 * ORA-10702 Cannot reach ncvservicet:40003
 */
    function ft_phonetic_search (
        piv_nachname              in varchar2,
        piv_vorname               in varchar2,
        piv_firmenname            in varchar2 default null,
        piv_strasse               in varchar2 default null,
        piv_hausnummer            in varchar2 default null,
        piv_plz                   in varchar2 default null,
        piv_ort                   in varchar2 default null,
        pin_ignore_service_errors in natural default null
    ) return t_fuzzy_persons
        pipelined
    is

        c_ignore_service_errors constant boolean := pin_ignore_service_errors = 1;
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name         constant logs.routine_name%type := 'ft_phonetic_search';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('piv_nachname', piv_nachname);
            pck_format.p_add('piv_vorname', piv_vorname);
            pck_format.p_add('piv_firmenname', piv_firmenname);
            pck_format.p_add('piv_strasse', piv_strasse);
            pck_format.p_add('piv_hausnummer', piv_hausnummer);
            pck_format.p_add('piv_plz', piv_plz);
            pck_format.p_add('piv_ort', piv_ort);
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------   
    begin
        g_ignore_service_errors := c_ignore_service_errors; -- um die Prüfung in p_check_response_errors auszusetzen
    -- Plausi-Prüfung der Parameter:
        if
            piv_nachname is null
            and piv_vorname is null
            and piv_firmenname is null
            and piv_strasse is null
            and piv_hausnummer is null
            and piv_plz is null
            and piv_ort is null
        then
            return; -- RAISE_APPLICATION_ERROR(c_plausi_error_number, 'Duplikatcheck "Phonetische Suche": Alle zu prüfenden Felder sind leer');
        end if;

        for matcheslist in (
            with fuzzydouble as (
                select
                    fx_phonetic_search(
                        piv_nachname   => piv_nachname,
                        piv_vorname    => piv_vorname,
                        piv_firmenname => piv_firmenname,
                        piv_strasse    => piv_strasse,
                        piv_hausnummer => piv_hausnummer,
                        piv_plz        => piv_plz,
                        piv_ort        => piv_ort
                    ) as response
                from
                    dual
            )
            select
                row_id,
                rule_number,
                score,
                vorname,
                nachname,
                geburtsdatum,
                firmenname,
                strasse,
                hausnummer,
                plz,
                ort,
                iban,
                kontonummer,
                bic
            from
                fuzzydouble,
                xmltable ( '//*/MatchesList/Record'
                        passing fuzzydouble.response
                    columns
                        row_id varchar2(100) path '@rowId',
                        rule_number integer path '@ruleNumber',
                        score integer path '@score',
                        vorname varchar2(100) path 'Firstname',
                        nachname varchar2(100) path 'Lastname',
                        geburtsdatum varchar2(8) path 'Birthday',
                        firmenname varchar2(100) path 'Companyname',
                        strasse varchar2(100) path 'Street',
                        hausnummer varchar2(30) path 'HouseNr',
                        plz varchar2(10) path 'Zipcode',
                        ort varchar2(100) path 'City',
                        iban varchar2(100) path 'BankIBAN',
                        kontonummer varchar2(100) path 'BankAccountNr',
                        bic varchar2(30) path 'BankIdentificationCode'
                ) parsed
        ) loop
            pipe row ( new t_fuzzy_person(src_pho, matcheslist.row_id, null -- //////// Kundennummer gleich hier hinzufügen!!!
            , matcheslist.rule_number, matcheslist.score,
                                          matcheslist.vorname, matcheslist.nachname, to_date(matcheslist.geburtsdatum, 'YYYYMMDD'), matcheslist.firmenname
                                          ,
                                          matcheslist.strasse, matcheslist.hausnummer, matcheslist.plz, matcheslist.ort, matcheslist.iban
                                          ,
                                          matcheslist.kontonummer, matcheslist.bic) );
        end loop;

        return;
    exception
        when no_data_needed then -- Pipelined Function Standardbehandlung
            return;
        when e_service_not_reachable then
            if c_ignore_service_errors then
                return;
            else
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );

                raise;
            end if;
        when others then
            if sqlcode <> c_plausi_error_number then -- nur technische Fehler loggen:
                pck_logs.p_error(
                    pic_message      => fcl_params(),
                    piv_routine_name => qualified_name(cv_routine_name),
                    piv_scope        => g_scope
                );
            end if;

            raise;
    end ft_phonetic_search;
    
  
/**
 * Ermittelt im Fehlerfall den Error-Code sowie den Fehlerstring
 * in der Antwort des Fuzzydouble-Servers; bei Erfolg bleiben die OUT-Parameter leer
 *
 * @param pix_response  [IN ] Vollständige Response des Servers
 * @param piv_xpath     [IN ] Falls bekannt, kann hier der XPath-Ausdruck bis
 *                            zur Fehlerliste angegeben werden, dies macht die Suche performanter
 * @param pov_errorcode [OUT] Leer, wenn der originale Errorcode = 200 ist (dies bedeutet Erfolg),
 *                            ansonsten der Inhalt des Tags <InternalErrorCode>
 * @param pov_errortext [OUT] Leer, wenn der Errorcode = 200 ist und der Fehlertext = 'OK' w?,
 *                            ansonsten der Inhalt des Tags <InternalErrorText>
 *  
 */
    procedure p_parse_response_errors (
        pix_response  in xmltype,
        piv_xpath     in varchar2 default null,
        pov_errorcode out varchar2,
        pov_errortext out varchar2
    ) is
    begin
        pov_errorcode := apex_web_service.parse_xml(
            p_xml   => pix_response,
            p_xpath => c_xpath_errors_bankresponse || '/InternalErrorCode',
            p_ns    => c_fuzzydouble_namespace
        );

        pov_errorcode := replace(pov_errorcode, '<InternalErrorCode>');
        pov_errorcode := replace(pov_errorcode, '</InternalErrorCode>');
        pov_errorcode := replace(pov_errorcode,
                                 chr(10)); -- kann Spuren von Zeilenumbrüchen enthalten
  
    -- Den Errortext nur dann parsen, wenn ein Fehler vorliegt:
        if nvl(pov_errorcode, '-') not like '%200%' then
            pov_errortext := apex_web_service.parse_xml(
                p_xml   => pix_response,
                p_xpath => c_xpath_errors_bankresponse || '/InternalErrorText',
                p_ns    => c_fuzzydouble_namespace
            );

            pov_errortext := replace(pov_errortext, '<InternalErrorText>');
            pov_errortext := replace(pov_errortext, '</InternalErrorText>');
        end if;

    end p_parse_response_errors;
/**  
 * Wirft eine Exception, wenn in der Fuzzydouble-Antwort ein anderer
 * Errorcode als 200 vorkommt
 *
 * @param pix_response  Ungeparste Antwort vom FuzzyDouble-Server
 * @param piv_xpath     Falls bekannt, kann hier der XPath-Ausdruck bis
 *                      zur Fehlerliste angegeben werden, dies macht die Suche performanter
 * @usage   Nach dem Erhalt einer Serverantwort diese Prodzedur aufrufen: 
 *          Sofern der Returncode = 200 ist passiert nichts, ansonsten wird eine Exception
 *          an die aufrufende Prozedur hochgereicht
 * @throws  User Defined Exception, wenn der returnierte Errorcode einen anderen Wert als 200 hat
 *          (der SQLCODE liegt dann zwischen -20001 und -20999: Returncode 500 ergibt beispielsweise -20500).
 *          Alle anderen Exceptions werden geraised.
 */
    procedure p_check_response_errors (
        pix_response in xmltype,
        piv_xpath    in varchar2 default null
    ) is
        v_errorcode varchar2(255);
        v_errortext varchar2(4000);
    begin
    -- neu 2024-02-08:
        if g_ignore_service_errors then
            return;
        end if;
        p_parse_response_errors(
            pix_response  => pix_response,
            piv_xpath     => piv_xpath,
            pov_errorcode => v_errorcode,
            pov_errortext => v_errortext
        );
    -- Beispiele für v_errorcode:
    -- 10702 Cannot reach ncvhalp:40103
        if v_errorcode <> 200 then
      -- z.B. -20999:
            raise_application_error(-20000 -(greatest(1,
                                                      least(999, v_errorcode))),
                                    v_errortext);
        end if;

    end p_check_response_errors;
  
/**  
 * Liefert die Ergebnisse der Dublettenprüfung für die Glascontainer-Bestellstrecke
 *
 * @param piv_nachname              [IN]  Nachname des Bestellers (nicht case-sensitiv)
 * @param piv_vorname               [IN]  Vorname des Bestellers (nicht case-sensitiv)
 * @param pid_geburtsdatum          [IN]  Geburtstag des Bestellers
 * @param piv_firmenname            [IN]  ggf. Firmenname des Bestellers (nicht case-sensitiv)
 * @param piv_strasse               [IN]  Installationsadresse: Straße  (nicht case-sensitiv)
 * @param piv_hausnummer            [IN]  Installationsadresse: Haunr. inkl. Zusatz  (nicht case-sensitiv)
 * @param piv_plz                   [IN]  Installationsadresse: Postleitzahl
 * @param piv_ort                   [IN]  Installationsadresse: Ort  (nicht case-sensitiv)
 * @param piv_iban                  [IN]  Bankverbindung: IBAN (nicht case-sensitiv)
 * @param pin_ignore_service_errors [IN]  (optional, default: 0) Wenn 1, dann werden keine Fehler geworfen, wenn
 *                                        Fuzzy nicht erreichbar ist (typischerweise ist das so in der Entwicklungsumgebung)
 * @param pin_find_1_only           [IN]  (optional, default: 0) Wenn 1, dann kehrt die Funktion bereits mit der
 *                                        ersten gefundenen Dublette zurück (hilfreich, wenn APEX lediglich wissen möchte,
 *                                        ob mindestens eine Dublette existiert)
 * @piv_suchbereich                 [IN]  (optional) (NULL): Sämtliche Quellen durchsuchen
 *                                                   SIE   : Siebel durchsuchen (nicht den Glascontainer)
 *                                                   PHO   : Siebel durchsuchen, aber nur phonetisch
 *                                                   BNK   : Siebel durchsuchen, aber nur IBAN-Suche
 *                                                   POB   : Preorderbuffer durchsuchen (nicht Siebel)
 *                                                   POB-N : Preorderbuffer durchsuchen, aber nur Neukundenaufträge
 *                                                   POB-B : Preorderbuffer durchsuchen, aber nur Bestandskundenaufträge 
 * 
 * @return T_FUZZY_PERSONS PIPELINED 
 *
 * @ticket FTTH-2804
 *
-- @deprecated, ersetzt durch PCK_GLASCONTAINER_ORDER.ft_vorbestellung_dublettencheck
--              aufgrund der extrem schlechten Performance der Fuzzy-Einzelvergleiche in der Produktion
  FUNCTION ft_vorbestellung_dublettencheck (
      piv_nachname          IN VARCHAR2
     ,piv_vorname           IN VARCHAR2
     ,pid_geburtsdatum      IN DATE
     ,piv_firmenname        IN VARCHAR2
     ,piv_strasse           IN VARCHAR2
     ,piv_hausnummer        IN VARCHAR2
     ,piv_plz               IN VARCHAR2
     ,piv_ort               IN VARCHAR2
     ,piv_iban              IN VARCHAR2
     ,pin_ignore_service_errors IN NATURAL DEFAULT 0
     ,pin_find_1_only       IN NATURAL DEFAULT 0
     ,piv_suchbereich       IN VARCHAR2 DEFAULT NULL
  )
  RETURN t_fuzzy_persons PIPELINED
  IS
    -- Bestimmt, wie präzise im Glascontainer/Preorderbuffer nach Duplikation gesucht wird:
    C_EDIT_DISTANCE         CONSTANT NATURALN := 2; -- 0 = exakter Treffer, 1 = nah dran, ... 100 = völlig unterschiedlich
    C_ENVIRONMENT           VARCHAR2(100); -- z.B. NMCE3
    C_FUZZYDOUBLE_AVAILABLE BOOLEAN;
    C_FAKE_FUZZYDOUBLE_DATA BOOLEAN;
    C_FAKE_POB_DATA         BOOLEAN;
    
    -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
      cv_routine_name CONSTANT logs.routine_name%TYPE := 'ft_vorbestellung_dublettencheck';
      FUNCTION fcl_params RETURN logs.message%TYPE IS
      BEGIN
        pck_format.p_add('piv_nachname',              piv_nachname);
        pck_format.p_add('piv_vorname',               piv_vorname);
        pck_format.p_add('pid_geburtsdatum',          pid_geburtsdatum);
        pck_format.p_add('piv_firmenname',            piv_firmenname);
        pck_format.p_add('piv_strasse',               piv_strasse);
        pck_format.p_add('piv_hausnummer',            piv_hausnummer);
        pck_format.p_add('piv_plz',                   piv_plz);
        pck_format.p_add('piv_ort',                   piv_ort);
        pck_format.p_add('piv_iban',                  piv_iban);
        pck_format.p_add('pin_ignore_service_errors', pin_ignore_service_errors);
        pck_format.p_add('piv_suchbereich',           piv_suchbereich);
        RETURN pck_format.fcl_params(cv_routine_name);
      END fcl_params;
    -- /Hilfsroutine zur Fehlerbehandlung ---------------------------------------- 
  BEGIN
    -- nur in der Produktion kann Fuzzy noch abgefragt werden;
    -- in den anderen Umgebungen besteht der Dienst bereits nicht mehr
    C_ENVIRONMENT           := pck_env.fv_db_name;
    C_FUZZYDOUBLE_AVAILABLE := C_ENVIRONMENT = 'NMC';
    -- "Spieldaten" gibt es nur in der Enwicklungs- und Testumgebung:
    C_FAKE_FUZZYDOUBLE_DATA := NOT C_FUZZYDOUBLE_AVAILABLE AND
                               C_ENVIRONMENT IN ('NMCE', 'NMCE3', 'NMCS');
    C_FAKE_POB_DATA         := C_ENVIRONMENT IN ('NMCE', 'NMCE3');
    
    -- Am wenigsten aufwändige Suche zuerst:
    -- Suche im Preorderbuffer über persönliche Daten oder IBAN  
    IF piv_suchbereich IS NULL OR
    piv_suchbereich IN ('POB', 'POB-N', 'POB-B') THEN
        FOR chk_pob IN (
        -- Vergleiche Adresse oder IBAN im Preorder-Buffer:
        SELECT  SRC_POB                 AS SRC
             , 'POB'                    AS LINK -- //// anders benennen
             , 'Auftrag in neuem Glascontainer-Fenster öffnen ...' AS LINK_TITLE
             , id                       AS id
             , customernumber           AS kundennummer
             , NULL                     AS rule_number
             , NULL                     AS score
             , customer_name_first      AS vorname
             , customer_name_last       AS nachname
             , customer_birthdate       AS geburtsdatum
             , customer_businessname    AS firmenname
             , install_addr_street      AS strasse
             , install_addr_housenumber AS hausnummer
             , install_addr_zipcode     AS plz
             , install_addr_city        AS ort
             , account_iban             AS iban
          FROM ftth_ws_sync_preorders
         WHERE state IN ('CREATED', 'IN_REVIEW', 'SIEBEL_PROCESSED')
           AND -- rudimentäre Ähnlichkeitssuche im Preorderbuffer.
               -- Aufträge werden als potenzielle Dubletten betrachtet, wenn...:
               (    -- Fall 1: IBAN ist identisch
                    -------------------------------------------------------------------------------------------------------------
                       upper(account_iban) = upper(REPLACE(piv_iban, ' '))
                       
                    OR -- oder Fall 2: Vor- und Nachname sind sehr ähnlich
                    -------------------------------------------------------------------------------------------------------------
                       (UTL_MATCH.edit_distance(upper(customer_name_last), upper(piv_nachname)) BETWEEN 0 AND C_EDIT_DISTANCE AND 
                        UTL_MATCH.edit_distance(upper(customer_name_first), upper(piv_vorname)) BETWEEN 0 AND C_EDIT_DISTANCE
                       ) 
                       -- /// Geburtsdatum vergleichen?
                       
                    OR -- oder Fall 3: Firmenname ist sehr ähnlich:
                    -------------------------------------------------------------------------------------------------------------
                    UTL_MATCH.edit_distance(upper(customer_businessname), upper(piv_firmenname)) BETWEEN 0 AND C_EDIT_DISTANCE
                       
                    OR -- oder Fall 4: Die Adresse ist sehr ähnlich, wobei PLZ und Hausnummer (nicht Zusatz) identisch sein müssen und
                       -- Straße bzw. Ort sehr ähnlich:
                    -------------------------------------------------------------------------------------------------------------
                       (install_addr_zipcode = piv_plz AND
                        UTL_MATCH.edit_distance(upper(install_addr_street), upper(piv_strasse)) BETWEEN 0 AND C_EDIT_DISTANCE AND
                        install_addr_housenumber = piv_hausnummer AND -- Zusatz wird ignoriert
                        UTL_MATCH.edit_distance(upper(install_addr_city), upper(piv_ort)) BETWEEN 0 AND C_EDIT_DISTANCE
                       )
               )
         -- /// auch mit HAUS_LFD_NR, Tel, Email etc. vergleichen?
        ) LOOP
            PIPE ROW (
                NEW t_fuzzy_person (
                     chk_pob.SRC
                   , chk_pob.id
                   , chk_pob.kundennummer -- neu 2024-05-22
                   , chk_pob.rule_number
                   , chk_pob.score
                   , chk_pob.vorname
                   , chk_pob.nachname
                   , chk_pob.geburtsdatum
                   , chk_pob.firmenname
                   , chk_pob.strasse
                   , chk_pob.hausnummer
                   , chk_pob.plz
                   , chk_pob.ort
                   , chk_pob.iban
                   , NULL -- kontonummer
                   , NULL -- BIC
                 ) 
            );
            IF pin_find_1_only = 1 THEN RETURN; END IF;
        END LOOP;
        
        IF C_FAKE_POB_DATA THEN
        -- MOCK/FAKE/DEMO-DATEN aus dem POB:
        -- /0/
        PIPE ROW (
                        NEW t_fuzzy_person (
                             'POB'
                           , 'rPZaERggl1AgIjPrw1PQ16m0ctV5pg'
                           , ''
                           , 1
                           , 85
                           , 'Jane'
                           , 'Doe'
                           , DATE '2000-01-01'
                           , ''
                           , 'Marconistr.'
                           , '16'
                           , '50769'
                           , 'Koeln'
                           , 'DE02120300000000202051'
                           , NULL -- kontonummer
                           , NULL -- BIC
                         ) 
                    );
        END IF; -- /Fake POB
    END IF; -- /Suchbereich POB
    
    
    
    -- SIEBEL,
    -- Vergleich über persönliche Daten:
    IF piv_suchbereich IS NULL OR
       piv_suchbereich IN ('SIE', 'PHO') THEN
          IF C_FAKE_FUZZYDOUBLE_DATA THEN
              FOR siebel_perfekter_bestandskunde in (
                select global_id, kundennummer
                     , anrede
                     , CASE UPPER(ANREDE) WHEN 'HERR' THEN 'MISTER' WHEN 'FRAU' THEN 'MISS' END
                     , TITEL 
                     , VORNAME
                     , NACHNAME
                     , GEBURTSDATUM
                     , FIRMENNAME
                     , STRASSE
                     , HAUSNR_von AS HAUSNUMMER
                     , PLZ
                     , ORT
                     , AP_EMAIL
                     , AP_MOBIL_COUNTRY
                     , AP_MOBIL_ONKZ || AP_X_MOBIL_NR
                     , IBAN
                  from v_siebel_kundendaten 
                 where gueltig = 'Y' and
                       -- perfekter Bestandskunde:
                       anrede is not null and
                       vorname is not null and
                       regexp_like(TRIM(BOTH '-' FROM TRIM(nachname)), '^[a-zA-Z \-]{2,30}$') and
                       geburtsdatum is not null and
                       ap_email is not null and
                       ap_mobil_country is not null and
                       AP_MOBIL_ONKZ || AP_X_MOBIL_NR is not null and
                       iban is not null    -- //// eigentlich müsste man auch die IBAN auf Gültigkeit prüfen....     
              ) LOOP
                    PIPE ROW (
                        NEW t_fuzzy_person (
                             'SIE'                                        -- src
                           , siebel_perfekter_bestandskunde.global_id     -- row_id (global_id)
                           , siebel_perfekter_bestandskunde.kundennummer  -- kundennummer
                           , 1                                            -- rule_number
                           , 85                                           -- score
                           , siebel_perfekter_bestandskunde.vorname       -- Vorname
                           , siebel_perfekter_bestandskunde.nachname      -- Nachname
                           , siebel_perfekter_bestandskunde.geburtsdatum  -- Geburtsdatum
                           , siebel_perfekter_bestandskunde.firmenname    -- Firmenname
                           , siebel_perfekter_bestandskunde.strasse       -- Straße
                           , siebel_perfekter_bestandskunde.hausnummer    -- Hausnummer
                           , siebel_perfekter_bestandskunde.plz           -- PLZ
                           , siebel_perfekter_bestandskunde.ort           -- Ort
                           , siebel_perfekter_bestandskunde.iban          -- IBAN
                           , ''                                           -- Kontonummer
                           , ''                                           -- BIC
                         ) 
                    );
                    EXIT; -- Schluss nach einer Zeile  
              END LOOP;
          -- /Fake: perfekter Bestandskunde
              
              FOR siebel_geburtsdatum_fehlt in (
                select global_id, kundennummer
                     , anrede
                     , CASE UPPER(ANREDE) WHEN 'HERR' THEN 'MISTER' WHEN 'FRAU' THEN 'MISS' END
                     , TITEL 
                     , VORNAME
                     , NACHNAME
                     , GEBURTSDATUM
                     , FIRMENNAME
                     , STRASSE
                     , HAUSNR_von AS HAUSNUMMER
                     , PLZ
                     , ORT
                     , AP_EMAIL
                     , AP_MOBIL_COUNTRY
                     , AP_MOBIL_ONKZ || AP_X_MOBIL_NR
                     , IBAN
                  from v_siebel_kundendaten 
                 where gueltig = 'Y' and
                       anrede IS NOT NULL and
                       vorname is NOT null and
                       regexp_like(TRIM(BOTH '-' FROM TRIM(nachname)), '^[a-zA-Z \-]{2,30}$') and
                       geburtsdatum is  null and -- Geburtsdatum fehlt
                       ap_email is not null and
                       ap_mobil_country is not null and
                       AP_MOBIL_ONKZ || AP_X_MOBIL_NR is not null and
                       iban is not null         
              ) LOOP
                    PIPE ROW (
                        NEW t_fuzzy_person (
                             'SIE'                                        -- src
                           , siebel_geburtsdatum_fehlt.global_id     -- row_id (global_id)
                           , siebel_geburtsdatum_fehlt.kundennummer  -- kundennummer
                           , 1                                            -- rule_number
                           , 85                                           -- score
                           , siebel_geburtsdatum_fehlt.vorname       -- Vorname
                           , siebel_geburtsdatum_fehlt.nachname      || ' [Geburtsdatum fehlt]' 
                           , siebel_geburtsdatum_fehlt.geburtsdatum  -- Geburtsdatum
                           , siebel_geburtsdatum_fehlt.firmenname    -- Firmenname
                           , siebel_geburtsdatum_fehlt.strasse       -- Straße
                           , siebel_geburtsdatum_fehlt.hausnummer    -- Hausnummer
                           , siebel_geburtsdatum_fehlt.plz           -- PLZ
                           , siebel_geburtsdatum_fehlt.ort           -- Ort
                           , siebel_geburtsdatum_fehlt.iban          -- IBAN
                           , ''                                           -- Kontonummer
                           , ''                                           -- BIC
                         ) 
                    );
                    EXIT; -- Schluss nach einer Zeile  
              END LOOP;
              -- /Fake: Geburtsdatum fehlt
              
              
              FOR siebel_email_fehlt in (
                select global_id, kundennummer
                     , anrede
                     , CASE UPPER(ANREDE) WHEN 'HERR' THEN 'MISTER' WHEN 'FRAU' THEN 'MISS' END
                     , TITEL 
                     , VORNAME
                     , NACHNAME
                     , GEBURTSDATUM
                     , FIRMENNAME
                     , STRASSE
                     , HAUSNR_von AS HAUSNUMMER
                     , PLZ
                     , ORT
                     , AP_EMAIL
                     , AP_MOBIL_COUNTRY
                     , AP_MOBIL_ONKZ || AP_X_MOBIL_NR
                     , IBAN
                  from v_siebel_kundendaten 
                 where gueltig = 'Y' and
                       anrede IS NOT NULL and
                       vorname is NOT null and
                       regexp_like(TRIM(BOTH '-' FROM TRIM(nachname)), '^[a-zA-Z \-]{2,30}$') and
                       geburtsdatum is not null and
                       ap_email is null and -- Email fehlt
                       ap_mobil_country is not null and
                       AP_MOBIL_ONKZ || AP_X_MOBIL_NR is not null and
                       iban is not null         
              ) LOOP
                    PIPE ROW (
                        NEW t_fuzzy_person (
                             'SIE'                                        -- src
                           , siebel_email_fehlt.global_id     -- row_id (global_id)
                           , siebel_email_fehlt.kundennummer  -- kundennummer
                           , 1                                            -- rule_number
                           , 85                                           -- score
                           , siebel_email_fehlt.vorname       -- Vorname
                           , siebel_email_fehlt.nachname      || ' [Email fehlt]' 
                           , siebel_email_fehlt.geburtsdatum  -- Geburtsdatum
                           , siebel_email_fehlt.firmenname    -- Firmenname
                           , siebel_email_fehlt.strasse       -- Straße
                           , siebel_email_fehlt.hausnummer    -- Hausnummer
                           , siebel_email_fehlt.plz           -- PLZ
                           , siebel_email_fehlt.ort           -- Ort
                           , siebel_email_fehlt.iban          -- IBAN
                           , ''                                           -- Kontonummer
                           , ''                                           -- BIC
                         ) 
                    );
                    EXIT; -- Schluss nach einer Zeile  
              END LOOP;
              -- /Fake: Email fehlt              
             
        --/Fake-Daten SIEBEL----------------------------------------------------------
          END IF; -- /C_FAKE_FAUZZYDOUBLE_DATA
    
    -- kein Fuzzy? Dann ist hier Schluss.
    IF NOT C_FUZZYDOUBLE_AVAILABLE THEN RETURN; END IF;
    -- SIEBEL,
    -- Phonetische Suche:
    FOR chk_pho IN (
        SELECT
            F.row_id,
            F.rule_number,
            F.score,
            F.vorname,
            F.nachname,
            F.geburtsdatum,
            F.firmenname,
            F.strasse,
            F.hausnummer,
            F.plz,
            F.ort,
            F.iban,
            S.kundennummer -- neu 2024-05-22
        FROM
            TABLE ( pck_fuzzydouble.ft_phonetic_search(
                      piv_nachname    => piv_nachname
                    , piv_vorname     => piv_vorname
                    , piv_firmenname  => piv_firmenname
                    , piv_strasse     => piv_strasse
                    , piv_hausnummer  => piv_hausnummer
                    , piv_plz         => piv_plz
                    , piv_ort         => piv_ort
                    , pin_ignore_service_errors => pin_ignore_service_errors
                    )
            ) F
        JOIN v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf S
          ON (F.ROW_ID = S.global_id)
        ) LOOP    
              PIPE ROW (
                NEW t_fuzzy_person (
                     SRC_PHO
                   , chk_pho.row_id
                   , chk_pho.kundennummer
                   , chk_pho.rule_number
                   , chk_pho.score
                   , chk_pho.vorname
                   , chk_pho.nachname
                   , chk_pho.geburtsdatum
                   , chk_pho.firmenname
                   , chk_pho.strasse
                   , chk_pho.hausnummer
                   , chk_pho.plz
                   , chk_pho.ort
                   , chk_pho.iban
                   , NULL -- kontonummer
                   , NULL -- BIC
                )
              );
              IF pin_find_1_only = 1 THEN RETURN; END IF;
        END LOOP;
    END IF;
        
    -- SIEBEL,
    -- Vergleich über IBAN:
    IF piv_suchbereich IS NULL OR
    piv_suchbereich IN ('SIE', 'BNK') THEN
        FOR chk_bnk IN (   
        SELECT 
            F.row_id,
            F.rule_number,
            F.score,
            F.vorname,
            F.nachname,
            F.geburtsdatum,
            F.firmenname,
            F.strasse,
            F.hausnummer,
            F.plz,
            F.ort,
            F.iban,
            S.kundennummer
         FROM TABLE(PCK_FUZZYDOUBLE.ft_doublet_check_bank( -- //// @kundennummer ist es nicht möglich, die Kundennummer gleich dort abzufragen anstatt hier ein JOIN aufzumachen?
                        piv_iban => piv_iban
                      , pin_ignore_service_errors => pin_ignore_service_errors
                    )
              ) F
         JOIN v_apx_gc_customerdata@siebp.netcologne.intern@siebel_inf S
          ON (F.ROW_ID = S.global_id)
        ) LOOP           
          PIPE ROW (
            NEW t_fuzzy_person (
                 SRC_BNK
               , chk_bnk.row_id
               , chk_bnk.kundennummer
               , chk_bnk.rule_number
               , chk_bnk.score
               , chk_bnk.vorname
               , chk_bnk.nachname
               , chk_bnk.geburtsdatum
               , chk_bnk.firmenname
               , chk_bnk.strasse
               , chk_bnk.hausnummer
               , chk_bnk.plz
               , chk_bnk.ort
               , chk_bnk.iban
               , NULL -- kontonummer
               , NULL -- BIC
            )
          );
          IF pin_find_1_only = 1 THEN RETURN; END IF;
        END LOOP;     
        
    END IF;
--/SIEBEL----------------------------------------------------------
  
    RETURN;
  EXCEPTION
      WHEN NO_DATA_NEEDED THEN RETURN;    
      WHEN OTHERS THEN
        pck_logs.p_error(
           pic_message      => fcl_params()
          ,piv_routine_name => cv_routine_name
        );
        RAISE;
  END; 
 */
end pck_fuzzydouble;
/

