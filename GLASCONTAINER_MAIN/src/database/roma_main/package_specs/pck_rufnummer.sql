create or replace package pck_rufnummer as 
/**
 * Hilfsroutinen zur Formatierung von Telefonnummern
 *
 * @creation 2023-12-07  Andreas Wismann  <wismann@when-others.com>
 * @usage    @ticket FTTH-2904
 *
 */

  -- Test auf Umlaute/Euro: ÄÖÜäöüß/?

  -- Wird angezeigt auf der Seite 10050 "Über diese Anwendung".
  -- Der gesamte String sollte als Ganzes aufsteigend sortierbar sein
  -- (an erster Stelle ist also das Datum maßgeblich)
  -- so dass die aktuellere Version stets lexikalisch "später" einsortiert werden kann.
    version constant varchar2(30) := '2024-06-26 1030';
    type t_extended_lov is record (
            return_value  varchar2(255),
            display_value varchar2(255),
            info_1        varchar2(255),
            info_2        varchar2(255)
    );
    type t_extended_lov_table is
        table of t_extended_lov;
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
        deterministic;

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
 * @usage Existiert die Ländervorwahl nicht, so obliegt es dem aufrufenden Programm,
 *        diese voranzustellen (z.B. typischerweise '49' ...), andernfalls entspricht
 *        der Rückgabestring nicht den Erwartungen.
 * @usage Es werden auch internationale Vorwahlen akzeptiert.
 * @usage Es wird nicht geprüft, ob die Rufnummer tatsächlich valide ist,
 *        lediglich das Format des Rückgabestrings wird der Spezifikation E.164 entsprechen
 */
    function fv_e164 (
        piv_rufnummer in varchar2
    ) return varchar2
        deterministic;

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
        deterministic;

  -- Nur intern und für Testzwecke zugänglich:
    function fv_laendervorwahl (
        i_rufnummer in varchar2
    ) return varchar2
        deterministic
        accessible by ( package ut_rufnummer );   


  -- Nur intern und für Testzwecke zugänglich:
    procedure split_laendervorwahl (
        i_rufnummer      in varchar2,
        o_laendervorwahl out varchar2,
        o_land           out varchar2
    )
        accessible by ( package ut_rufnummer ); 

/**
 * Gibt alle in der Glasfaser-Bestellstrecke erlaubten Landesvorwahlen als List of Values zurück
 *
 * @doc https://netwelt.netcologne.intern/pages/viewpage.action?pageId=179872959
 * @example
 * SELECT DISPLAY_VALUE, RETURN_VALUE FROM TABLE(PCK_RUFNUMMER.FP_LAENDERVORWAHL_BESTELLSTRECKE)
 */
    function fp_laendervorwahl_bestellstrecke return t_extended_lov_table
        pipelined;

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
        deterministic;

end pck_rufnummer;
/


-- sqlcl_snapshot {"hash":"737678bc965f98892eab7c119c1f7f2a03afec55","type":"PACKAGE_SPEC","name":"PCK_RUFNUMMER","schemaName":"ROMA_MAIN","sxml":""}