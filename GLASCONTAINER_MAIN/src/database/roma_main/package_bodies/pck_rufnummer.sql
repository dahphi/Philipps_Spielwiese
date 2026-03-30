create or replace package body pck_rufnummer as 
/**
 * Hilfsroutinen zur Formatierung von Telefonnummern
 *
 * @creation 2023-12-07  Andreas Wismann  <wismann@when-others.com>
 * @usage    @ticket FTTH-2904
 */

  -- Test auf Umlaute/Euro: ÄÖÜäöüß/?

  -- Im Unterschied zu PCK_RUFNUMMER.version ist die Version im PACKAGE BODY
  -- meist höher (die informelle APEX-Abfrage auf Seite 2022:10050 ermittelt den 
  -- höheren der beiden Werte über die FUNCTION get_body_version)

    body_version constant varchar2(30) := '2024-09-11 0930';
    not_a_number constant varchar2(30) := '[^[:digit:]]'; -- RegEx, findet alle nicht-nummerischen Zeichen
  --------
    function na return varchar2 is
    begin
        return null;
    end na;
  --------
    procedure na is
    begin
        null;
    end na;

/**
 * Gibt anhand dreier separater Bestandteile einer Festnetz- oder Mobil-Rufnummer
 * einen formatierten Rufnummer-Gesamtstring zurück, der sich als
 * singulärer Text beispielweise in einem Report anzeigen lässt, und fehlende
 * Teilbereiche durch '--?--' ersetzt
 *
 * @param piv_1            [IN ]  Erster Teil (Ländervorwahl)
 * @param piv_2            [IN ]  Zweiter Teil (Ortnetz / Mobilnetz-Vorwahl)
 * @param piv_3            [IN ]  Rufnummer
 * @param piv_leerzeichen  [IN ]  Ersetzt das Default-Leerzeichen zwischen den Teilbereichen;
 *                                kann beispielsweise auf NULL gesetzt werden, um keine
 *                                Trennzeichen zu verwenden
 *
 * @see https://de.wikipedia.org/wiki/E.164
 * @see https://de.wikipedia.org/wiki/E.123
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 *
 * @usage   APEX-App 1200:900
 *
 * @unittest
 * SELECT * FROM TABLE (UT.RUN('ROMA_MAIN.UT_RUFNUMMER'))
 *
 * @example
 * SELECT PCK_RUFNUMMER.fv_anzeige('49', '02131', NULL) FROM DUAL -- '+49 2131 --?--'
 *
 * @date 2023-10-26 
 */
    function fv_anzeige (
        piv_1           in varchar2,
        piv_2           in varchar2,
        piv_3           in varchar2,
        piv_leerzeichen in varchar2 default chr(32)
    ) return varchar2
        deterministic
    is
    begin 
    -- Trivialfall: Eine Pseudo-Rufnummer wurde gespeichert
        if
            piv_2 is null
            and piv_3 is null
            and ( piv_1 is null
                  or (
                piv_1 like '%49%'
                and length(piv_1) <= 5
            ) -- z.B. "(49)-", Quelle: Report "Bestandskunden PK IR" App 1200 Seite 900
             )
        then
            return null;
        end if;

    -- Normalfall:
        return trim(

      -- Laenderkennzeichen:
      ----------------------------------------------------------------------------
            case
                when piv_1 is not null then
                    '+'
                    || trim(leading '+' from trim(leading '0' from replace(
                        replace(piv_1, '('),
                        ')'
                    )))
            end
            || piv_leerzeichen

      -- Netzvorwahl:
      ----------------------------------------------------------------------------
            ||
            case
                when trim(piv_2) is not null then
                    trim(leading '0' from trim(replace(
                        replace(piv_2, '('),
                        ')'
                    )))
                else '--?--'
            end
            || piv_leerzeichen

      -- Rufnummer:
      ----------------------------------------------------------------------------
            || case
            when trim(piv_3) is not null then
                trim(piv_3)
            else '--?--'
        end
      ----------------------------------------------------------------------------
        );

    end fv_anzeige;



/**
 * Wandelt eine vollständig übergebene Rufnummer ins E.164-Format um, soweit dies
 * möglich ist, ansonsten wird sie 1:1 zurückgegeben
 *
 * @param piv_rufnummer [IN ]  Vollständige Rufnummer inklusive Vorwahl, darf mit '+' beginnen
 *                             und darf die üblichen Formatierungszeichen
 *                             besitzen (z.B. '+49 (0)2131 6699-51')
 *
 * @return Formatierte Rufnummer im Erfolgsfall, ansonsten der Eingabestring
 *
 * @usage Existiert die Läervorwahl nicht, so obliegt es dem aufrufenden Programm,
 *        diese voranzustellen (z.B. typischerweise '49' ...), andernfalls entspricht
 *        der Rückgabestring nicht den Erwartungen.
 * @usage Es werden auch internationale Vorwahlen akzeptiert.
 * @usage Es wird nicht geprüft, ob die Rufnummer tatsächlich valide ist,
 *        lediglich das Format des Rückgabestrings wird der Spezifikation E.164 entsprechen
 */
    function fv_e164 (
        piv_rufnummer in varchar2
    ) return varchar2
        deterministic
    is

        v_rufnummer      varchar2(255);
        v_laendervorwahl varchar2(4);
        fehlerfall       constant varchar2(30) := piv_rufnummer; -- Die Rufnummer wird 1:1 zurückgegeben
    begin
    -- Alle nicht-nummerischen Bestandteile entfernen
        v_rufnummer := trim(leading '0' from regexp_replace(piv_rufnummer, not_a_number));
        if v_rufnummer is null then
            return null;
        end if;

    -- Fehlerfall 1: Es kommen ausschließlich Buchstaben oder Sonderzeichen vor:
        if
            trim(piv_rufnummer) is not null
            and v_rufnummer is null
        then
            return fehlerfall;
        end if;  

    -- Fehlerfall 2: Nummer ist zu lang gemäß Spezifikation
        if length(v_rufnummer) > 15 then
            return fehlerfall;
        end if;
        v_laendervorwahl := fv_laendervorwahl(v_rufnummer);
        return '+'
               || v_laendervorwahl
               || trim(leading '0' from substr(v_rufnummer,
                                               1 + length(v_laendervorwahl)));
--  EXCEPTION
--    WHEN OTHERS THEN RETURN NULL;
    end fv_e164;


/**
 * Gibt anhand dreier separater Bestandteile einer Festnetz- oder Mobil-Rufnummer
 * einen formatierten Rufnummer-Gesamtstring im Format E.164 zurück, der sich als
 * singulärer Text beispielweise in einem Report anzeigen lässt.
 *
 * @param piv_1 [IN ]  Ländervorwahl, darf mit '+' beginnen
 * @param piv_2 [IN ]  Ortsnetzvorwahl oder Mobilnetzvorwahl, darf mit '0' beginnen
 *                     und die üblichen Formatierungszeichen besitzen (z.B. '(0)2131')
 * @param piv_3 [IN ]  Rufnummer, darf die üblichen Formatierungszeichen besitzen (z.B. '6699-51') 
 *
 * @return Formatierte Rufnummer im Erfolgsfall, ansonsten NULL
 *
 * @usage Existiert die Ländervorwahl (piv_1) nicht, so obliegt es dem aufrufenden Programm,
 *        diese voranzustellen (z.B. typischerweise '49' ...), andernfalls wird NULL zurückgegeben.
 * @usage Es werden auch internationale Vorwahlen akzeptiert.
 * @usage Es wird nicht geprüft, ob die Rufnummer tatsächlich valide ist,
 *        lediglich das Format des Rückgabestrings wird der Spezifikation E.164 entsprechen   
 *
 * @usage Zurückgegeben wird NULL, wenn sich aus den übergebenen Bestandteilen
 *        keine valide Standard-Telefonnummer bilden lässt, etwa weil die
 *        Ländervorwahl fehlt
 *
 * @see https://www.itu.int/rec/T-REC-E.164-201011-I/en
 * @see https://www.itu.int/rec/dologin_pub.asp?lang=e&id=T-REC-E.164-201011-I!!PDF-E&type=items
 *
 * @author  WISAND  Andreas Wismann  <wismann@when-others.com>
 *
 * @usage   APEX-App 1200:900
 *
 * @unittest
 * SELECT * FROM TABLE (UT.RUN('ROMA_MAIN.UT_RUFNUMMER'))
 *
 * @date 2023-12-07 
 */
    function fv_e164 (
        piv_1 in varchar2,
        piv_2 in varchar2,
        piv_3 in varchar2
    ) return varchar2
        deterministic
    is

        v_rufnummer varchar2(255);
        v_1         varchar2(3);  -- Country Code
        v_2         varchar2(15); -- National Destination Code
        v_3         varchar2(15); -- Subscriber Number
        fehlercode  constant varchar2(15) := '';
    begin

    -- Alle nicht-nummerischen Bestandteile entfernen
        v_1 := trim(leading '0' from regexp_replace(piv_1, not_a_number));
        v_2 := trim(leading '0' from regexp_replace(piv_2, not_a_number));
        v_3 := regexp_replace(piv_3, not_a_number);

    -- Fehlerfall 1: Keine der Eingaben enthält eine Nummer
        if
            v_1 is null
            and v_2 is null
            and v_3 is null
        then
            return null;
        end if;

    -- Fehlerfall: Irgendein Bestandteil der Rufnummer fehlt
        if v_1 is null
           or v_2 is null
        or v_3 is null then
            return fehlercode;
        end if;  

    -- Normalfall:
        v_rufnummer := trim(
          -- Laenderkennzeichen:
        v_1 -- || piv_leerzeichen
          -- Netzvorwahl:
                            || v_2 -- || piv_leerzeichen
          -- Rufnummer:
                            || v_3);

    -- Fehlerfall 3: Nummer ist zu lang gemäß Spezifikation
        if length(v_rufnummer) > 15 then
            return fehlercode;
        end if;
        return '+' || v_rufnummer;
    exception
        when others then
            return null;
    end fv_e164;


  -- Wird benötigt von vf_e164, nicht exportieren.
    procedure split_laendervorwahl (
        i_rufnummer      in varchar2,
        o_laendervorwahl out varchar2,
        o_land           out varchar2
    )
        accessible by ( package ut_rufnummer )
    is

        v_rufnummer     varchar2(4000);
        v_zone          varchar2(1);
        v_region        varchar2(3);
        v_subregion     varchar2(2);
  -- Hilfsroutine zur Fehlerbehandlung------------------------------------------
        cv_routine_name constant logs.routine_name%type := 'split_laendervorwahl';

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('i_rufnummer', i_rufnummer);
      -- (OUT): o_laendervorwahl
      -- (OUT): o_land
            return pck_format.fcl_params(cv_routine_name);
        end fcl_params;
  -- /Hilfsroutine zur Fehlerbehandlung ----------------------------------------     
    --------
        function land (
            i_vorwahl in varchar2,
            i_land    in varchar2
        ) return varchar2
            deterministic
        is
        begin
            o_laendervorwahl := i_vorwahl;
            return i_land;
        end;
    --------
        function nicht_vergeben (
            i_nummer in varchar2
        ) return varchar2
            deterministic
        is
        begin
            o_laendervorwahl := null; -- zeigt an, dass es nicht funktioniert hat
            return '+'
                   || i_nummer
                   || ' (nicht vergeben)'; -- ///
        end;  
    --------
        function unbekannt (
            i_nummer in varchar2
        ) return varchar2
            deterministic
        is
        begin
            return '+'
                   || i_nummer
                   || ' (unbekannt)'; -- ///
        end;

    begin
        v_rufnummer := trim(leading '0' from regexp_replace(i_rufnummer, not_a_number));
        if v_rufnummer is null then
            return;
        end if;
        v_zone := substr(v_rufnummer, 1, 1);
        case v_zone
      ----------------------------------------------------------------------------
            when '1' then -- Nordamerikanischer Nummerierungsplan (NANP)
                v_region := substr(v_rufnummer, 2, 3);
                o_land :=
                    case v_region
                        when '242' then
                            land(v_zone || v_region, 'Bahamas')
                        when '246' then
                            land(v_zone || v_region, 'Barbados')
                        when '264' then
                            land(v_zone || v_region, 'Anguilla')
                        when '268' then
                            land(v_zone || v_region, 'Antigua und Barbuda')
                        when '284' then
                            land(v_zone || v_region, 'Britische Jungferninseln')
                        when '340' then
                            land(v_zone || v_region, 'Amerikanische Jungferninseln')
                        when '345' then
                            land(v_zone || v_region, 'Kaimaninseln')
                        when '441' then
                            land(v_zone || v_region, 'Bermuda')
                        when '473' then
                            land(v_zone || v_region, 'Grenada')
                        when '649' then
                            land(v_zone || v_region, 'Turks- und Caicosinseln')
                        when '664' then
                            land(v_zone || v_region, 'Montserrat')
                        when '670' then
                            land(v_zone || v_region, 'Nördliche Marianen')
                        when '671' then
                            land(v_zone || v_region, 'Guam')
                        when '684' then
                            land(v_zone || v_region, 'Amerikanisch-Samoa')
                        when '721' then
                            land(v_zone || v_region, 'Sint Maarten') -- (fr?her +599)
                        when '758' then
                            land(v_zone || v_region, 'St. Lucia')
                        when '767' then
                            land(v_zone || v_region, 'Dominica')
                        when '784' then
                            land(v_zone || v_region, 'St. Vincent und die Grenadinen')
                        when '787' then
                            land(v_zone || v_region, 'Puerto Rico') -- (s. +1 939)
                        when '808' then
                            land(v_zone || v_region, 'Hawaii')
                        when '809' then
                            land(v_zone || v_region, 'Dominikanische Republik') -- (s. +1 829)
                        when '829' then
                            land(v_zone || v_region, 'Dominikanische Republik') -- (s. +1 809)
                        when '849' then
                            land(v_zone || v_region, 'Dominikanische Republik') -- (s. +1 809)
                        when '868' then
                            land(v_zone || v_region, 'Trinidad und Tobago')
                        when '869' then
                            land(v_zone || v_region, 'St. Kitts und Nevis')
                        when '876' then
                            land(v_zone || v_region, 'Jamaika')
                        when '939' then
                            land(v_zone || v_region, 'Puerto Rico') -- (s. +1 787)
                        else land(v_zone || v_region, 'USA, Kanada') -- ///// weiter aufdröseln -- Große Länder sind in mehrere NPAs aufgeteilt
                    end;
      ----------------------------------------------------------------------------
            when '2' then -- Afrika, Atlantikinseln und Inseln im Indischen Ozean
                v_region := substr(v_rufnummer, 1, 3); -- zB. '233'
                v_subregion := substr(v_region, 1, 2);
                o_land :=
                    case v_subregion
                        when '20' then
                            land(v_subregion, 'Äypten')
                        when '27' then
                            land(v_subregion, 'Südafrika')
                        when '28' then
                            nicht_vergeben(v_subregion)
                        else
                    case v_region
                                when '210' then
                                    nicht_vergeben(v_region)
                                when '211' then
                                    land(v_region, 'Südsudan')
                                when '212' then
                                    land(v_region, 'Marokko')
                                when '213' then
                                    land(v_region, 'Algerien')
                                when '214' then
                                    nicht_vergeben(v_region)
                                when '215' then
                                    nicht_vergeben(v_region)
                                when '216' then
                                    land(v_region, 'Tunesien')
                                when '217' then
                                    nicht_vergeben(v_region)
                                when '218' then
                                    land(v_region, 'Libyen')
                                when '219' then
                                    nicht_vergeben(v_region)
                                when '220' then
                                    land(v_region, 'Gambia')
                                when '221' then
                                    land(v_region, 'Senegal')
                                when '222' then
                                    land(v_region, 'Mauretanien')
                                when '223' then
                                    land(v_region, 'Mali')
                                when '224' then
                                    land(v_region, 'Guinea')
                                when '225' then
                                    land(v_region, 'Elfenbeinküste (Côte d''Ivoire)')
                                when '226' then
                                    land(v_region, 'Burkina Faso (ehem. Obervolta)')
                                when '227' then
                                    land(v_region, 'Niger')
                                when '228' then
                                    land(v_region, 'Togo')
                                when '229' then
                                    land(v_region, 'Benin')
                                when '230' then
                                    land(v_region, 'Mauritius')
                                when '231' then
                                    land(v_region, 'Liberia')
                                when '232' then
                                    land(v_region, 'Sierra Leone')
                                when '233' then
                                    land(v_region, 'Ghana')
                                when '234' then
                                    land(v_region, 'Nigeria')
                                when '235' then
                                    land(v_region, 'Tschad')
                                when '236' then
                                    land(v_region, 'Zentralafrikanische Republik')
                                when '237' then
                                    land(v_region, 'Kamerun')
                                when '238' then
                                    land(v_region, 'Kap Verde')
                                when '239' then
                                    land(v_region, 'São Tomé und Príncipe')
                                when '240' then
                                    land(v_region, 'Äquatorialguinea')
                                when '241' then
                                    land(v_region, 'Gabun')
                                when '242' then
                                    land(v_region, 'Republik Kongo (Brazzaville)')
                                when '243' then
                                    land(v_region, 'Demokratische Republik Kongo (Zaire)')
                                when '244' then
                                    land(v_region, 'Angola')
                                when '245' then
                                    land(v_region, 'Guinea-Bissau')
                                when '246' then
                                    land(v_region, 'Britisches Territorium im Indischen Ozean (Diego-Garcia)')
                                when '247' then
                                    land(v_region, 'Ascension')
                                when '248' then
                                    land(v_region, 'Seychellen')
                                when '249' then
                                    land(v_region, 'Sudan')
                                when '250' then
                                    land(v_region, 'Ruanda')
                                when '251' then
                                    land(v_region, 'Äthiopien')
                                when '252' then
                                    land(v_region, 'Somalia')
                                when '253' then
                                    land(v_region, 'Dschibuti')
                                when '254' then
                                    land(v_region, 'Kenia')
                                when '255' then
                                    land(v_region, 'Tansania')
                                when '256' then
                                    land(v_region, 'Uganda')
                                when '257' then
                                    land(v_region, 'Burundi')
                                when '258' then
                                    land(v_region, 'Mosambik')
                                when '259' then
                                    nicht_vergeben(v_region)
                                when '260' then
                                    land(v_region, 'Sambia')
                                when '261' then
                                    land(v_region, 'Madagaskar')
                                when '262' then
                                    land(v_region, 'Französische Gebiete im Indischen Ozean')
                                when '263' then
                                    land(v_region, 'Simbabwe')
                                when '264' then
                                    land(v_region, 'Namibia')
                                when '265' then
                                    land(v_region, 'Malawi')
                                when '266' then
                                    land(v_region, 'Lesotho')
                                when '267' then
                                    land(v_region, 'Botswana')
                                when '268' then
                                    land(v_region, 'Eswatini')
                                when '269' then
                                    land(v_region, 'Komoren')
                                when '290' then
                                    land(v_region, 'St. Helena')
                                when '291' then
                                    land(v_region, 'Eritrea')
                                when '292' then
                                    nicht_vergeben(v_region)
                                when '293' then
                                    nicht_vergeben(v_region)
                                when '294' then
                                    nicht_vergeben(v_region)
                                when '295' then
                                    nicht_vergeben(v_region)
                                when '296' then
                                    nicht_vergeben(v_region)
                                when '297' then
                                    land(v_region, 'Aruba')
                                when '298' then
                                    land(v_region, 'Färöer')
                                when '299' then
                                    land(v_region, 'Grönland')
                            end
                    end;
      ----------------------------------------------------------------------------
            when '3' then -- Europa
                v_region := substr(v_rufnummer, 1, 3); -- zB. '358' für Finnland
                v_subregion := substr(v_region, 1, 2); -- zB. '34' für Spanien

                o_land :=
                    case v_subregion
                        when '30' then
                            land(v_subregion, 'Griechenland')
                        when '31' then
                            land(v_subregion, 'Niederlande')
                        when '32' then
                            land(v_subregion, 'Belgien')
                        when '33' then
                            land(v_subregion, 'Frankreich')
                        when '34' then
                            land(v_subregion, 'Spanien')
                        when '36' then
                            land(v_subregion, 'Ungarn')
                        when '39' then
                            land(v_subregion, 'Italien')
                        else
                    case v_region
                                when '350' then
                                    land(v_region, 'Gibraltar Gibraltar')
                                when '351' then
                                    land(v_region, 'Portugal')
                                when '352' then
                                    land(v_region, 'Luxemburg')
                                when '353' then
                                    land(v_region, 'Irland')
                                when '354' then
                                    land(v_region, 'Island')
                                when '355' then
                                    land(v_region, 'Albanien')
                                when '356' then
                                    land(v_region, 'Malta')
                                when '357' then
                                    land(v_region, 'Zypern')
                                when '358' then
                                    land(v_region, 'Finnland')
                                when '359' then
                                    land(v_region, 'Bulgarien')
                                when '370' then
                                    land(v_region, 'Litauen')
                                when '371' then
                                    land(v_region, 'Lettland')
                                when '372' then
                                    land(v_region, 'Estland')
                                when '373' then
                                    land(v_region, 'Moldau')
                                when '374' then
                                    land(v_region, 'Armenien')
                                when '375' then
                                    land(v_region, 'Belarus')
                                when '376' then
                                    land(v_region, 'Andorra')
                                when '377' then
                                    land(v_region, 'Monaco')
                                when '378' then
                                    land(v_region, 'San Marino')
                                when '379' then
                                    land(v_region, 'Vatikanstadt')
                                when '380' then
                                    land(v_region, 'Ukraine')
                                when '381' then
                                    land(v_region, 'Serbien')
                                when '382' then
                                    land(v_region, 'Montenegro')
                                when '383' then
                                    land(v_region, 'Kosovo')
                                when '384' then
                                    nicht_vergeben(v_region)
                                when '385' then
                                    land(v_region, 'Kroatien')
                                when '386' then
                                    land(v_region, 'Slowenien')
                                when '387' then
                                    land(v_region, 'Bosnien und Herzegowina')
                                when '388' then
                                    nicht_vergeben(v_region)
                                when '389' then
                                    land(v_region, 'Nordmazedonien')
                            end
                    end;
      ----------------------------------------------------------------------------
            when '4' then -- Europa (Fortsetzung)
                v_region := substr(v_rufnummer, 1, 3); -- zB. '423' für Liechtenstein
                v_subregion := substr(v_region, 1, 2); -- zB. '49' für Deutschland    

                o_land :=
                    case v_subregion
                        when '40' then
                            land(v_subregion, 'Rumänien')
                        when '41' then
                            land(v_subregion, 'Schweiz')
                        when '43' then
                            land(v_subregion, 'Österreich')
                        when '44' then
                            land(v_subregion, 'Vereinigtes Königreich')
                        when '45' then
                            land(v_subregion, 'Dänemark')
                        when '46' then
                            land(v_subregion, 'Schweden')
                        when '47' then
                            land(v_subregion, 'Norwegen')
                        when '48' then
                            land(v_subregion, 'Polen')
                        when '49' then
                            land(v_subregion, 'Deutschland')
                        else
                    case v_region
                                when '420' then
                                    land(v_region, 'Tschechien')
                                when '421' then
                                    land(v_region, 'Slowakei')
                                when '422' then
                                    nicht_vergeben(v_region)
                                when '423' then
                                    land(v_region, 'Liechtenstein')
                                when '424' then
                                    nicht_vergeben(v_region)
                                when '425' then
                                    nicht_vergeben(v_region)
                                when '426' then
                                    nicht_vergeben(v_region)
                                when '427' then
                                    nicht_vergeben(v_region)
                                when '428' then
                                    nicht_vergeben(v_region)
                                when '429' then
                                    nicht_vergeben(v_region)
                            end
                    end;
      ----------------------------------------------------------------------------
            when '5' then -- Mexiko, Zentralamerika und Südamerika
                v_region := substr(v_rufnummer, 1, 3);
                v_subregion := substr(v_region, 1, 2);
                o_land :=
                    case v_subregion
                        when '51' then
                            land(v_subregion, 'Peru')
                        when '52' then
                            land(v_subregion, 'Mexiko')
                        when '53' then
                            land(v_subregion, 'Kuba')
                        when '54' then
                            land(v_subregion, 'Argentinien')
                        when '55' then
                            land(v_subregion, 'Brasilien')
                        when '56' then
                            land(v_subregion, 'Chile')
                        when '57' then
                            land(v_subregion, 'Kolumbien')
                        when '58' then
                            land(v_subregion, 'Venezuela')
                        else
                    case v_region
                                when '500' then
                                    land(v_region, 'Falklandinseln')
                                when '501' then
                                    land(v_region, 'Belize')
                                when '502' then
                                    land(v_region, 'Guatemala')
                                when '503' then
                                    land(v_region, 'El Salvador')
                                when '504' then
                                    land(v_region, 'Honduras')
                                when '505' then
                                    land(v_region, 'Nicaragua')
                                when '506' then
                                    land(v_region, 'Costa Rica')
                                when '507' then
                                    land(v_region, 'Panama')
                                when '508' then
                                    land(v_region, 'Saint-Pierre und Miquelon')
                                when '509' then
                                    land(v_region, 'Haiti')
                                when '590' then
                                    land(v_region, 'Guadeloupe,  St. Martin,  Saint-Barthélemy')
                                when '591' then
                                    land(v_region, 'Bolivien')
                                when '592' then
                                    land(v_region, 'Guyana')
                                when '593' then
                                    land(v_region, 'Ecuador')
                                when '594' then
                                    land(v_region, 'Französisch-Guayana')
                                when '595' then
                                    land(v_region, 'Paraguay')
                                when '596' then
                                    land(v_region, 'Martinique')
                                when '597' then
                                    land(v_region, 'Suriname')
                                when '598' then
                                    land(v_region, 'Uruguay')
                                when '599' then
                                    land(v_region, 'Bonaire, Curaçao, Saba, Sint Eustatius')
                            end
                    end;
      ----------------------------------------------------------------------------
            when '6' then -- S?dpazifik und Ozeanien
                v_region := substr(v_rufnummer, 1, 3);
                v_subregion := substr(v_region, 1, 2);
                o_land :=
                    case v_subregion
                        when '60' then
                            land(v_subregion, 'Malaysia')
                        when '61' then
                            land(v_subregion, 'Australien')
                        when '62' then
                            land(v_subregion, 'Indonesien')
                        when '63' then
                            land(v_subregion, 'Philippinen')
                        when '64' then
                            land(v_subregion, 'Neuseeland')
                        when '65' then
                            land(v_subregion, 'Singapur')
                        when '66' then
                            land(v_subregion, 'Thailand')
                        else
                    case v_region
                                when '670' then
                                    land(v_region, 'Osttimor')
                                when '671' then
                                    nicht_vergeben(v_region)
                                when '672' then
                                    land(v_region, 'Antarktis,  Norfolkinsel')
                                when '673' then
                                    land(v_region, 'Brunei')
                                when '674' then
                                    land(v_region, 'Nauru')
                                when '675' then
                                    land(v_region, 'Papua-Neuguinea')
                                when '676' then
                                    land(v_region, 'Tonga')
                                when '677' then
                                    land(v_region, 'Salomonen')
                                when '678' then
                                    land(v_region, 'Vanuatu')
                                when '679' then
                                    land(v_region, 'Fidschi')
                                when '680' then
                                    land(v_region, 'Palau (Belau)')
                                when '681' then
                                    land(v_region, 'Wallis und Futuna')
                                when '682' then
                                    land(v_region, 'Cookinseln')
                                when '683' then
                                    land(v_region, 'Niue')
                                when '684' then
                                    nicht_vergeben(v_region)
                                when '685' then
                                    land(v_region, 'Samoa')
                                when '686' then
                                    land(v_region, 'Kiribati, Gilbertinseln')
                                when '687' then
                                    land(v_region, 'Neukaledonien')
                                when '688' then
                                    land(v_region, 'Tuvalu, Elliceinseln')
                                when '689' then
                                    land(v_region, 'Französisch-Polynesien')
                                when '690' then
                                    land(v_region, 'Tokelau')
                                when '691' then
                                    land(v_region, 'Föderierte Staaten von Mikronesien')
                                when '692' then
                                    land(v_region, 'Marshallinseln')
                                when '693' then
                                    nicht_vergeben(v_region)
                                when '694' then
                                    nicht_vergeben(v_region)
                                when '695' then
                                    nicht_vergeben(v_region)
                                when '696' then
                                    nicht_vergeben(v_region)
                                when '697' then
                                    nicht_vergeben(v_region)
                                when '698' then
                                    nicht_vergeben(v_region)
                                when '699' then
                                    nicht_vergeben(v_region)
                            end
                    end;
      ----------------------------------------------------------------------------
            when '7' then -- Russland & russ. besetzte Gebiete 
                o_land := land(v_zone, 'Russland');
      ----------------------------------------------------------------------------
            when '8' then -- Ostasien und Sondernummern
                v_region := substr(v_rufnummer, 1, 3);
                v_subregion := substr(v_region, 1, 2);
                o_land :=
                    case v_subregion
                        when '81' then
                            land(v_subregion, 'Japan')
                        when '82' then
                            land(v_subregion, 'Südkorea')
                        when '83' then
                            nicht_vergeben(v_subregion)
                        when '84' then
                            land(v_subregion, 'Vietnam')
                        when '86' then
                            land(v_subregion, 'Volksrepublik China')
                        when '89' then
                            nicht_vergeben(v_subregion)
                        else
                    case v_region
                                when '800' then
                                    land(v_region, 'Internationale Free-Phone-Dienste')
                                when '801' then
                                    nicht_vergeben(v_region)
                                when '802' then
                                    nicht_vergeben(v_region)
                                when '803' then
                                    nicht_vergeben(v_region)
                                when '804' then
                                    nicht_vergeben(v_region)
                                when '805' then
                                    nicht_vergeben(v_region)
                                when '806' then
                                    nicht_vergeben(v_region)
                                when '807' then
                                    nicht_vergeben(v_region)
                                when '808' then
                                    land(v_region, 'Internationale Service-Dienste')
                                when '809' then
                                    nicht_vergeben(v_region)
                                when '850' then
                                    land(v_region, 'Nordkorea')
                                when '851' then
                                    nicht_vergeben(v_region)
                                when '852' then
                                    land(v_region, 'Hongkong')
                                when '853' then
                                    land(v_region, 'Macau')
                                when '854' then
                                    nicht_vergeben(v_region)
                                when '855' then
                                    land(v_region, 'Kambodscha')
                                when '856' then
                                    land(v_region, 'Laos')
                                when '857' then
                                    nicht_vergeben(v_region)
                                when '858' then
                                    nicht_vergeben(v_region)
                                when '859' then
                                    nicht_vergeben(v_region)
                                when '870' then
                                    land(v_region, 'Inmarsat Single Number Access (SNAC)')
                                when '871' then
                                    nicht_vergeben(v_region)
                                when '872' then
                                    nicht_vergeben(v_region)
                                when '873' then
                                    nicht_vergeben(v_region)
                                when '874' then
                                    nicht_vergeben(v_region)
                                when '875' then
                                    land(v_region, 'MARITIME Mobiltelefonie')
                                when '876' then
                                    land(v_region, 'MARITIME Mobiltelefonie')
                                when '877' then
                                    land(v_region, 'MARITIME Mobiltelefonie')
                                when '878' then
                                    land(v_region, 'UPT services')
                                when '879' then
                                    land(v_region, 'reserviert für nationale mobile beziehungsweise maritime Aufgaben')
                                when '880' then
                                    land(v_region, 'Bangladesch')
                                when '881' then
                                    land(v_region, 'Globales mobiles Satellitensystem')
                                when '882' then
                                    land(v_region, 'Internationale Netzwerke')
                                when '883' then
                                    land(v_region, 'Internationale Netzwerke (iNum)')
                                when '884' then
                                    nicht_vergeben(v_region)
                                when '885' then
                                    nicht_vergeben(v_region)
                                when '886' then
                                    land(v_region, 'Taiwan')
                                when '887' then
                                    nicht_vergeben(v_region)
                                when '888' then
                                    land(v_region, 'OCHA, Telecommunications for Disaster Relief (TDR)')
                                when '889' then
                                    nicht_vergeben(v_region)
                            end
                    end;
      ----------------------------------------------------------------------------
            when '9' then  -- West-, Zentral- und S?d-Asien, Naher Osten
                v_region := substr(v_rufnummer, 1, 3);
                v_subregion := substr(v_region, 1, 2);
                o_land :=
                    case v_subregion
                        when '90' then
                            land(v_subregion, 'Türkei')
                        when '91' then
                            land(v_subregion, 'Indien')
                        when '92' then
                            land(v_subregion, 'Pakistan')
                        when '93' then
                            land(v_subregion, 'Afghanistan')
                        when '94' then
                            land(v_subregion, 'Sri Lanka')
                        when '95' then
                            land(v_subregion, 'Myanmar')
                        when '98' then
                            land(v_subregion, 'Iran')
                        else
                    case v_region
                                when '960' then
                                    land(v_region, 'Malediven')
                                when '961' then
                                    land(v_region, 'Libanon')
                                when '962' then
                                    land(v_region, 'Jordanien')
                                when '963' then
                                    land(v_region, 'Syrien')
                                when '964' then
                                    land(v_region, 'Irak')
                                when '965' then
                                    land(v_region, 'Kuwait')
                                when '966' then
                                    land(v_region, 'Saudi-Arabien')
                                when '967' then
                                    land(v_region, 'Jemen')
                                when '968' then
                                    land(v_region, 'Oman')
                                when '969' then
                                    nicht_vergeben(v_region)
                                when '970' then
                                    land(v_region, 'Palästina')
                                when '971' then
                                    land(v_region, 'Vereinigte Arabische Emirate')
                                when '972' then
                                    land(v_region, 'Israel')
                                when '973' then
                                    land(v_region, 'Bahrain')
                                when '974' then
                                    land(v_region, 'Katar')
                                when '975' then
                                    land(v_region, 'Bhutan')
                                when '976' then
                                    land(v_region, 'Mongolei')
                                when '977' then
                                    land(v_region, 'Nepal')
                                when '978' then
                                    nicht_vergeben(v_region)
                                when '979' then
                                    land(v_region, 'Internationale Premium-Rate-Dienste')
                                when '990' then
                                    nicht_vergeben(v_region)
                                when '991' then
                                    land(v_region, 'International Telecommunications Public Correspondence Service Trials (ITPCS)')
                                when '992' then
                                    land(v_region, 'Tadschikistan')
                                when '993' then
                                    land(v_region, 'Turkmenistan')
                                when '994' then
                                    land(v_region, 'Aserbaidschan')
                                when '995' then
                                    land(v_region, 'Georgien')
                                when '996' then
                                    land(v_region, 'Kirgisistan')
                                when '997' then
                                    land(v_region, 'Kasachstan')
                                when '998' then
                                    land(v_region, 'Usbekistan')
                                when '999' then
                                    nicht_vergeben(v_region)
                            end
                    end;

        end case;

    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => cv_routine_name
            );
            raise;
    end split_laendervorwahl;

  -- Wird benötigt von vf_e164, nicht exportieren.
    function fv_laendervorwahl (
        i_rufnummer in varchar2
    ) return varchar2
        deterministic
        accessible by ( package ut_rufnummer )
    is
        v_laendervorwahl varchar2(4);
        v_land           varchar2(100);
    begin
        split_laendervorwahl(
            i_rufnummer      => i_rufnummer,
            o_laendervorwahl => v_laendervorwahl,
            o_land           => v_land
        );
        return v_laendervorwahl;
    end fv_laendervorwahl;

--@progress 2024-01-18----------------------------------------------------------  
/**
 * Gibt alle in der Glasfaser-Bestellstrecke erlaubten Landesvorwahlen als List of Values zurück
 *
 * @doc https://netwelt.netcologne.intern/pages/viewpage.action?pageId=179872959
 * @example
 * SELECT DISPLAY_VALUE, RETURN_VALUE FROM TABLE(PCK_RUFNUMMER.FP_LAENDERVORWAHL_BESTELLSTRECKE)
 */
    function fp_laendervorwahl_bestellstrecke return t_extended_lov_table
        pipelined
    is
    begin
        pipe row ( new t_extended_lov('1', 'USA, Kanada', null, null) );
        pipe row ( new t_extended_lov('20', 'Äypten', null, null) );
        pipe row ( new t_extended_lov('27', 'Südafrika', null, null) );
        pipe row ( new t_extended_lov('30', 'Griechenland', null, null) );
        pipe row ( new t_extended_lov('31', 'Niederlande', null, null) );
        pipe row ( new t_extended_lov('32', 'Belgien', null, null) );
        pipe row ( new t_extended_lov('33', 'Frankreich', null, null) );
        pipe row ( new t_extended_lov('34', 'Spanien', null, null) );
        pipe row ( new t_extended_lov('351', 'Portugal', null, null) );
        pipe row ( new t_extended_lov('352', 'Luxemburg', null, null) );
        pipe row ( new t_extended_lov('353', 'Irland', null, null) );
        pipe row ( new t_extended_lov('354', 'Island', null, null) );
        pipe row ( new t_extended_lov('358', 'Finnland', null, null) );
        pipe row ( new t_extended_lov('359', 'Bulgarien', null, null) );
        pipe row ( new t_extended_lov('36', 'Ungarn', null, null) );
        pipe row ( new t_extended_lov('380', 'Ukraine', null, null) );
        pipe row ( new t_extended_lov('39', 'Italien', null, null) );
        pipe row ( new t_extended_lov('41', 'Schweiz', null, null) );
        pipe row ( new t_extended_lov('420', 'Tschechien', null, null) );
        pipe row ( new t_extended_lov('43', 'Österreich', null, null) );
        pipe row ( new t_extended_lov('44', 'Vereinigtes Königreich', null, null) );
        pipe row ( new t_extended_lov('45', 'Dänemark', null, null) );
        pipe row ( new t_extended_lov('46', 'Schweden', null, null) );
        pipe row ( new t_extended_lov('47', 'Norwegen', null, null) );
        pipe row ( new t_extended_lov('48', 'Polen', null, null) );
        pipe row ( new t_extended_lov('49', 'Deutschland', null, null) );
        pipe row ( new t_extended_lov('52', 'Mexiko', null, null) );
        pipe row ( new t_extended_lov('54', 'Argentinien', null, null) );
        pipe row ( new t_extended_lov('55', 'Brasilien', null, null) );
        pipe row ( new t_extended_lov('56', 'Chile', null, null) );
        pipe row ( new t_extended_lov('58', 'Venezuela', null, null) );
        pipe row ( new t_extended_lov('60', 'Malaysia', null, null) );
        pipe row ( new t_extended_lov('61', 'Australien', null, null) );
        pipe row ( new t_extended_lov('62', 'Indonesien', null, null) );
        pipe row ( new t_extended_lov('63', 'Philippinen', null, null) );
        pipe row ( new t_extended_lov('64', 'Neuseeland', null, null) );
        pipe row ( new t_extended_lov('65', 'Singapur', null, null) );
        pipe row ( new t_extended_lov('66', 'Thailand', null, null) );
        pipe row ( new t_extended_lov('7', 'Russland', null, null) );
        pipe row ( new t_extended_lov('81', 'Japan', null, null) );
        pipe row ( new t_extended_lov('82', 'Südkorea', null, null) );
        pipe row ( new t_extended_lov('852', 'Hongkong', null, null) );
        pipe row ( new t_extended_lov('86', 'Volksrepublik China', null, null) );
        pipe row ( new t_extended_lov('886', 'Taiwan', null, null) );
        pipe row ( new t_extended_lov('90', 'Türkei', null, null) );
        pipe row ( new t_extended_lov('91', 'Indien', null, null) );
        pipe row ( new t_extended_lov('92', 'Pakistan', null, null) );
        pipe row ( new t_extended_lov('962', 'Jordanien', null, null) );
        pipe row ( new t_extended_lov('965', 'Kuwait', null, null) );
        pipe row ( new t_extended_lov('966', 'Saudi-Arabien', null, null) );
        pipe row ( new t_extended_lov('971', 'Vereinigte Arabische Emirate', null, null) );
        pipe row ( new t_extended_lov('972', 'Israel', null, null) );
    end;

-- @progress 2024-06-26
  /**
   * Gibt anhand dreier separater Bestandteile einer Festnetz- oder Mobil-Rufnummer
   * einen formatierten Rufnummer-Gesamtstring zurück, der sich als
   * singulärer Text beispielweise in einem Report anzeigen lässt
   *
   * @author  Andreas Wismann  WISAND  wismann@when-others.com
   *
   * @see https://de.wikipedia.org/wiki/E.164
   * @see https://de.wikipedia.org/wiki/E.123
   *
   * @usage Ersetzt die Standalone-Function FV_RUFNUMMER
   */
    function fv_rufnummer (
        piv_1           in varchar2,
        piv_2           in varchar2,
        piv_3           in varchar2,
        piv_leerzeichen in varchar2 default chr(32)
    ) return varchar2
        deterministic
    is
    begin
        return trim(

      -- Laenderkennzeichen:
      ----------------------------------------------------------------------------
            case
                when piv_1 is not null then
                    '+'
                    || trim(leading '+' from trim(leading '0' from replace(
                        replace(piv_1, '('),
                        ')'
                    )))
            end
            || piv_leerzeichen

      -- Netzvorwahl:
      ----------------------------------------------------------------------------
            ||
            case
                when trim(piv_2) is not null then
                    trim(leading '0' from trim(replace(
                        replace(piv_2, '('),
                        ')'
                    )))
                else '--?--'
            end
            || piv_leerzeichen

      -- Rufnummer:
      ----------------------------------------------------------------------------
            || case
            when trim(piv_3) is not null then
                trim(piv_3)
            else '--?--'
        end
      ----------------------------------------------------------------------------
        );
    end fv_rufnummer;

end;
/


-- sqlcl_snapshot {"hash":"6beb25a68e1a1fd894af875cf6e71df2aeb0382e","type":"PACKAGE_BODY","name":"PCK_RUFNUMMER","schemaName":"ROMA_MAIN","sxml":""}