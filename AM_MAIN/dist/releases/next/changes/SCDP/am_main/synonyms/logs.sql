-- liquibase formatted sql
-- changeset AM_MAIN:1774557120599 stripComments:false logicalFilePath:SCDP/am_main/synonyms/logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/logs.sql:null:af053becc3f1b301096ea1558be3957c564e7c01:create

create or replace editionable synonym am_main.logs for core.logs;

