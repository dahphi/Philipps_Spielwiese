-- liquibase formatted sql
-- changeset AM_MAIN:1774557120622 stripComments:false logicalFilePath:SCDP/am_main/synonyms/pck_env.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/pck_env.sql:null:e1a06529a917e4072eb1306a18a33a9e7f52cd27:create

create or replace editionable synonym am_main.pck_env for core.pck_env;

