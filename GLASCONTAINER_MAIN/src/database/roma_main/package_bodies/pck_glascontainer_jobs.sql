create or replace package body roma_main.pck_glascontainer_jobs as
 
  -- Umlaut-Test: ÄÖÜäöüß
  -- Eurozeichen: ? -- SELECT UNISTR('\20AC') FROM DUAL 

    body_version constant varchar2(30) := '2025-03-19 0830';


  
  /**
  * Gibt den Versionsstring des Package Bodies zurück
  */
    function get_body_version return varchar2
        deterministic
    is
    begin
        return body_version;
    end;  
 
 
 
 
/**
 * Nächtliche Tasks für den Glascontainer
 *
 * @job       Aufruf durch PROGRAM_GLASCONTAINER, geplant täglich um 05:15 Uhr
 * @unittest  SELECT * FROM TABLE(ut.run('UT_GLASCONTAINER', a_tags => 'glascontainer'));
 */
    procedure p_program_glascontainer is
    begin
        -- @ticket FTTH-5025: Entfernt alle nicht mehr zu verwendenen Kundendaten:
        pck_pob_rest.p_webservice_logs_loeschen();
        
        -- @ticket FTTH-4273, FTTH-4343:
        pck_glascontainer_ext.p_ausbaugebiete_aktualisieren();
        
        -- ... zukünftige weitere Tasks ...
    end;

end;
/


-- sqlcl_snapshot {"hash":"54336ab39cd5c480771517f7d274e6ee4c3f4990","type":"PACKAGE_BODY","name":"PCK_GLASCONTAINER_JOBS","schemaName":"ROMA_MAIN","sxml":""}