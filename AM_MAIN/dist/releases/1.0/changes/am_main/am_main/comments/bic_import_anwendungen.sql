-- liquibase formatted sql
-- changeset am_main:1774600096885 stripComments:false logicalFilePath:am_main/am_main/comments/bic_import_anwendungen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/bic_import_anwendungen.sql:null:4d80f236fdc0713b8b2f7101b86cf253a85be4e6:create

comment on column am_main.bic_import_anwendungen.guid is
    'GUID aus BIC';

comment on column am_main.bic_import_anwendungen.name is
    'Name der "Anwendung"';

comment on column am_main.bic_import_anwendungen.quelle is
    'Prozessname aus BIC
';

