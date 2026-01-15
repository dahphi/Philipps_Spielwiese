create or replace package pck_ftth_validate_email as
    -- Konstanten für Logging und Webservice-Kontext
    c_scope constant varchar2(30 char) := 'pck_ftth_validate_email';
    c_kontext constant varchar2(20 char) := 'WEBSERVICE';
    c_key1 constant varchar2(30 char) := 'FTTH_EMAIL_VALIDATION';
    c_key2 constant varchar2(20 char) := 'BASE_URL';

    -- Funktion: Validiert eine E-Mail-Adresse
    -- @param pi_email E-Mail-Adresse als Eingabe
    -- @return 'TRUE' bei Erfolg, sonst Fehlermeldung
    function f_validate_email (
        pi_email in varchar2
    ) return varchar2;

end pck_ftth_validate_email;
/


-- sqlcl_snapshot {"hash":"c8456205ec472e2b4eabd053ded87de69b2ba6e0","type":"PACKAGE_SPEC","name":"PCK_FTTH_VALIDATE_EMAIL","schemaName":"ROMA_MAIN","sxml":""}