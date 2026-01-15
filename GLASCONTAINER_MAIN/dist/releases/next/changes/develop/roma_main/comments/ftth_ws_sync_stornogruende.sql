-- liquibase formatted sql
-- changeset roma_main:1768480976812 stripComments:false logicalFilePath:develop/roma_main/comments/ftth_ws_sync_stornogruende.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/ftth_ws_sync_stornogruende.sql:null:26b3f493099be6f271dc1114939057bc6cfd0a63:create

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

