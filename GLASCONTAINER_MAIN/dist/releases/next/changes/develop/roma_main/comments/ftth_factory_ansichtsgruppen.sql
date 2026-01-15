-- liquibase formatted sql
-- changeset roma_main:1768480976108 stripComments:false logicalFilePath:develop/roma_main/comments/ftth_factory_ansichtsgruppen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/ftth_factory_ansichtsgruppen.sql:null:7091108bdb2960148c162c9bea91182b6b6a363f:create

comment on table roma_main.ftth_factory_ansichtsgruppen is
    'Kontrolle der Umsetzung der Fachkonzepte im #Ticket #CR3230. Wird verwendet in APEX 2022 Glascontainer. Nach Fertigstellung des MVP loeschbar.'
    ;

