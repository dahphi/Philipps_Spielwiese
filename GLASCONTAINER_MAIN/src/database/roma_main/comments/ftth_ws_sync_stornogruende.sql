comment on table roma_main.ftth_ws_sync_stornogruende is
    'Projekt Glascontainer: Von APEX erzeugt: Synchronisierungstabelle zum nächtlichen Abruf der Stornogründe';

comment on column roma_main.ftth_ws_sync_stornogruende.apex$row_sync_timestamp is
    'Von APEX erzeugt: Zeitstempel der letzten REST-Synchronisation';

comment on column roma_main.ftth_ws_sync_stornogruende.apex$sync_step_static_id is
    'Von APEX erzeugt: Step bei der REST-Synchronisation';

comment on column roma_main.ftth_ws_sync_stornogruende.key is
    'PK: Fachlicher Schlüssel für den Stornogrund';

comment on column roma_main.ftth_ws_sync_stornogruende.label is
    'Lesbarer Wert für den Stornogrund';

comment on column roma_main.ftth_ws_sync_stornogruende.notify_customer is
    '@ticket FTTH-4270: 
true=Kunde erhält bei Stornierungs eine Bestätigungsnachricht per E-Mail, false=Kunde erhält keine Stornobestätigungs-Mail';


-- sqlcl_snapshot {"hash":"bcf6c6625b0df8b8282a21d100192bcbc8683f6f","type":"COMMENT","name":"ftth_ws_sync_stornogruende","schemaName":"roma_main","sxml":""}