-- liquibase formatted sql
-- changeset AM_MAIN:1774600122952 stripComments:false logicalFilePath:am_main/am_main/synonyms/pck_apex_help.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/pck_apex_help.sql:null:8d93456f629c2af8849e73d172dbfcb3de1ff675:create

create or replace editionable synonym am_main.pck_apex_help for core.pck_apex_help;

