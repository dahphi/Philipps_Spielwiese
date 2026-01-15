-- liquibase formatted sql
-- changeset ROMA_MAIN:1768480989867 stripComments:false logicalFilePath:develop/roma_main/package_specs/pck_ftth_validate_email.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/package_specs/pck_ftth_validate_email.sql:null:09273cfb25fd633f992fb5f0b59e5122ef6fed8b:create

create or replace package roma_main.pck_ftth_validate_email as
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

