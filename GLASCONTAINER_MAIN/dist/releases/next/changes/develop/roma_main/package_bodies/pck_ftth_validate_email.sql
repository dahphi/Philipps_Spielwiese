-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480977213 stripComments:false logicalFilePath:develop/roma_main/package_bodies/pck_ftth_validate_email.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_bodies/pck_ftth_validate_email.sql:null:ccc378001e17a151e8932b772d3edf4c93f796e2:create

create or replace package body roma_main.pck_ftth_validate_email as
    -- Hilfsfunktion: Ermittelt die aktuelle DB-Umgebung (Instanzname)
    function f_get_db_env return varchar2 as

        c_unit constant logs.routine_name%type := $$plsql_unit
                                                  || '.'
                                                  || 'f_get_db_env';
        l_env  varchar2(100);
    begin
        -- Instanznamen bestimmen
        select
            sys_context('userenv', 'instance_name')
        into l_env
        from
            dual;

        return l_env;
    exception
        when others then 
            -- Fehlerlogging
            pck_logs.p_error(
                pic_message      => null,
                piv_routine_name => c_unit,
                piv_scope        => c_scope
            );

            raise;
    end f_get_db_env;

    -- Initialisiert die Webservice-Parameter (URL und Parameter)
    procedure p_init_webservice (
        po_url   out varchar2,
        po_param out varchar2
    ) as

        c_unit constant logs.routine_name%type := $$plsql_unit
                                                  || '.'
                                                  || 'p_init_webservice';
        l_env  varchar2(10 char);
    begin
        -- Umgebung bestimmen und dynamisch den Endpunkt ansprechen
        l_env := f_get_db_env;
        -- Setze URL anhand des Environments
        if l_env = 'NMCE' then
            po_url := 'https://e.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        elsif l_env = 'NMCU' then
            po_url := 'https://u.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        elsif l_env = 'NMCX' then
            po_url := 'https://x.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        elsif l_env = 'NMCX3' then
            po_url := 'https://x3.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        elsif l_env = 'NMCS' then
            po_url := 'https://s.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        elsif l_env = 'NMC' then
            po_url := 'https://p.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        else
            -- Fallback-URL falls kein Eintrag gefunden
            po_url := 'https://u.crmdatahub.svc.netcologne.intern/validate/v1/validate/email';
        end if;

        po_param := '?email=';
    exception
        when others then
            pck_logs.p_error(
                pic_message      => null,
                piv_routine_name => c_unit,
                piv_scope        => c_scope
            );

            raise;
    end p_init_webservice;

    -- Gibt eine deutsche Statusmeldung zum E-Mail-Status zurück
    function f_get_email_status_message (
        pi_status in varchar2
    ) return varchar2 is

        c_unit    constant logs.routine_name%type := $$plsql_unit
                                                  || '.'
                                                  || 'f_get_email_status_message';
        l_message varchar2(4000);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_status', pi_status);
            return pck_format.fcl_params(c_unit);
        end fcl_params;

    begin
        l_message :=
            case upper(trim(pi_status))
                when 'INVALID_SYNTAX' then
                    'Die eingegebene E-Mail-Adresse hat ein ungültiges Format. Bitte die Schreibweise überprüfen.'
                when 'LOW_QUALITY' then
                    'Die eingegebene E-Mail-Adresse wird nicht unterstützt. Bitte eine andere E-Mail-Adresse verwenden.'
                when 'LOW_DELIVERABILITY' then
                    'Die eingegebene E-Mail-Adresse kann aktuell nicht erreicht werden. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'INVALID_EMAIL' then
                    'Die eingegebene E-Mail-Adresse hat ein ungültiges Format. Bitte die Schreibweise überprüfen.'
                when 'INVALID_DOMAIN' then
                    'Die Domain der E-Mail-Adresse (nach dem @) existiert nicht. Bitte eine gültige E-Mail-Adresse angeben.'
                when 'REJECTED_EMAIL' then
                    'Die eingegebene E-Mail-Adresse kann nicht erreicht werden. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'DNS_ERROR' then
                    'Die Domain der E-Mail-Adresse (nach dem @) ist fehlerhaft. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'UNAVAILABLE_SMTP' then
                    'Der Mailserver der E-Mail-Adresse ist nicht erreichbar. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'UNSUPPORTED' then
                    'Die eingegebene E-Mail-Adresse kann nicht erreicht werden. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'UNKNOWN' then
                    'Die eingegebene E-Mail-Adresse kann nicht erreicht werden. Bitte die E-Mail-Adresse prüfen oder eine andere verwenden.'
                when 'ACCEPTED_EMAIL' then-- = Email passt und ist valide
                    null
                else pi_status
            end;

        return l_message;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => c_unit,
                piv_scope        => c_scope
            );

            raise;
    end f_get_email_status_message;

    -- Extrahiert den Status aus der JSON-Antwort des Webservices
    function f_get_email_status_from_json (
        pi_json in varchar2
    ) return varchar2 is

        c_unit    constant logs.routine_name%type := $$plsql_unit
                                                  || '.'
                                                  || 'f_get_email_status_from_json';
        l_valid   varchar2(5);
        l_reason  varchar2(50);
        l_message varchar2(4000);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_json', pi_json);
            return pck_format.fcl_params(c_unit);
        end fcl_params;

    begin
        select
            jt.valid,
            jt.reason
        into
            l_valid,
            l_reason
        from
                json_table ( pi_json, '$'
                    columns (
                        valid varchar2 ( 5 ) path '$.valid',
                        reason varchar2 ( 50 ) path '$.reason'
                    )
                )
            jt;

        l_message := f_get_email_status_message(l_reason);
        l_valid := upper(l_valid);
        if l_valid != 'TRUE' then
             -- Falls nicht valid dann Fehlermeldung
            return l_message;
        else
          -- Ansonsten TRUE zurückgeben
            return l_valid;
        end if;
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => c_unit,
                piv_scope        => c_scope
            );

            raise;
    end f_get_email_status_from_json;

    -- Hauptfunktion: Validiert eine E-Mail-Adresse über den Webservice
    function f_validate_email (
        pi_email in varchar2
    ) return varchar2 as

        c_unit     constant logs.routine_name%type := $$plsql_unit
                                                  || '.'
                                                  || 'f_validate_email';
        v_url      varchar2(255);
        v_param    varchar2(255);
        v_response varchar2(5000 char);

        function fcl_params return logs.message%type is
        begin
            pck_format.p_add('pi_email', pi_email);
            return pck_format.fcl_params(c_unit);
        end fcl_params;

    begin
        -- Webservice-Parameter initialisieren
        p_init_webservice(
            po_url   => v_url,
            po_param => v_param
        );
        -- URL zusammensetzen
        v_url := v_url
                 || v_param
                 || pi_email;
        -- dbms_output.put_line(v_url); -- Debug-Ausgabe
        -- REST-Request absetzen
        v_response := apex_web_service.make_rest_request(
            p_url         => v_url,
            p_http_method => 'GET'
        );
        -- dbms_output.put_line(v_response); -- Optional: Debug-Ausgabe
        -- Status aus JSON extrahieren
        v_response := f_get_email_status_from_json(pi_json => v_response);
        if v_response is null then
            v_response := 'TRUE'; -- Erfolg
        end if;
        return v_response;
        -- -- dbms_output.put_line(v_response); -- Optional: Debug-Ausgabe
    exception
        when others then
            pck_logs.p_error(
                pic_message      => fcl_params(),
                piv_routine_name => c_unit,
                piv_scope        => c_scope
            );

            raise;
    end f_validate_email;

end pck_ftth_validate_email;
/

