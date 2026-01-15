-- liquibase formatted sql
-- changeset roma_main:1768480976278 stripComments:false logicalFilePath:develop/roma_main/comments/ftth_webservice_aufrufe.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/ftth_webservice_aufrufe.sql:null:4fb03aeeb9c32ac422803bf9ed6d89c5ccfc0ff5:create

comment on table roma_main.ftth_webservice_aufrufe is
    'Protokolltabelle für Webservice-Aufrufe (APEX-Applikation 2022 Glascontainer)';

comment on column roma_main.ftth_webservice_aufrufe.app_user is
    'APEX-Anwendungsnutzer*in (4- oder 6-stelliges Kürzel)';

comment on column roma_main.ftth_webservice_aufrufe.response_body is
    'Falls der Webservice im Erfolgsfall einen Body zurücksendet, den der Client auswerten muss, so wird der Text des Bodys hier geloggt'
    ;

comment on column roma_main.ftth_webservice_aufrufe.testmodus is
    'TEST, falls der Webservice-Call nur simuliert wurde (siehe PCK_GLASCONTAINER.G_WS_TESTMODUS)';

