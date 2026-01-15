comment on table ftth_webservice_aufrufe is
    'Protokolltabelle für Webservice-Aufrufe (APEX-Applikation 2022 Glascontainer)';

comment on column ftth_webservice_aufrufe.app_user is
    'APEX-Anwendungsnutzer*in (4- oder 6-stelliges Kürzel)';

comment on column ftth_webservice_aufrufe.response_body is
    'Falls der Webservice im Erfolgsfall einen Body zurücksendet, den der Client auswerten muss, so wird der Text des Bodys hier geloggt'
    ;

comment on column ftth_webservice_aufrufe.testmodus is
    'TEST, falls der Webservice-Call nur simuliert wurde (siehe PCK_GLASCONTAINER.G_WS_TESTMODUS)';


-- sqlcl_snapshot {"hash":"182afe67dc92d6a9b579adc8ac004472dc7272a0","type":"COMMENT","name":"ftth_webservice_aufrufe","schemaName":"roma_main","sxml":""}