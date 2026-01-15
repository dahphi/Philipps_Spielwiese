create or replace package pck_glascontainer_jobs as 

/**
 * Sammelt alle Einstiegspunkte für Jobs, die im Zusammenhang mit der Applikation "Glascontainer" stehen
 *
 * @author Andreas Wismann  <wismann@when-others.com>
 * @date @creation 2025-03
 */

  -- Umlaut-Test: ÄÖÜäöüß
  -- Eurozeichen: ? -- SELECT UNISTR('\20AC') FROM DUAL 

    version constant varchar2(30) := '2025-03-11 1245';


  
/**
 * Gibt den Versionsstring des Package Bodies zurück
 */
    function get_body_version return varchar2
        deterministic;


        
/**
 * @ticket FTTH-5025: Entfernt alle nicht mehr zu verwendenen Kundendaten
 *
 * @job      Aufruf durch PROGRAM_GLASCONTAINER_BEREINIGEN, geplant täglich um 23:15 Uhr
 * @unittest  SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'glascontainer_bereinigen'));
 */
    procedure p_program_glascontainer;

end;
/


-- sqlcl_snapshot {"hash":"6c29a35cc08736d9f8e57d3c69d6b0688c417189","type":"PACKAGE_SPEC","name":"PCK_GLASCONTAINER_JOBS","schemaName":"ROMA_MAIN","sxml":""}