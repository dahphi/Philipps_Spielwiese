-- liquibase formatted sql
-- changeset roma_main:1768480976224 stripComments:false logicalFilePath:develop/roma_main/comments/ftth_produkte_gk.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot GLASCONTAINER_MAIN/src/database/roma_main/comments/ftth_produkte_gk.sql:null:c0435bc9e17c76d6535846d8a1e4d2ca8cf8d9cf:create

comment on table roma_main.ftth_produkte_gk is
    'Tabelle um die Produkte für GK abzubilden.';

comment on column roma_main.ftth_produkte_gk.fpgk_access_type is
    'Access Type des Produktes, dem die Produkte zugeordnet werden';

comment on column roma_main.ftth_produkte_gk.fpgk_id is
    'PK';

comment on column roma_main.ftth_produkte_gk.fpgk_produktname is
    'Name des Produktes, der angezeigt wird';

comment on column roma_main.ftth_produkte_gk.fpgk_status is
    'Status des Produktes. Wertemenge: AKTIV, INAKTIV';

comment on column roma_main.ftth_produkte_gk.fpgk_template_id is
    'Template ID des Produktes';

comment on column roma_main.ftth_produkte_gk.inserted is
    'Insert Datum';

comment on column roma_main.ftth_produkte_gk.inserted_by is
    'Insert User';

comment on column roma_main.ftth_produkte_gk.updated is
    'Update Datum';

comment on column roma_main.ftth_produkte_gk.updated_by is
    'Update User';

