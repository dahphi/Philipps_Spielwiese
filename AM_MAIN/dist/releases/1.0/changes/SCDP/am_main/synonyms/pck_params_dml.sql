-- liquibase formatted sql
-- changeset AM_MAIN:1774556572486 stripComments:false logicalFilePath:SCDP/am_main/synonyms/pck_params_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/pck_params_dml.sql:null:cb120b06c9f5f1253ed63f6909cb287904c73eba:create

create or replace editionable synonym am_main.pck_params_dml for core.pck_params_dml;

