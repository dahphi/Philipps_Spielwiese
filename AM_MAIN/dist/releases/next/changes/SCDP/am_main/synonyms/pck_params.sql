-- liquibase formatted sql
-- changeset AM_MAIN:1774557120634 stripComments:false logicalFilePath:SCDP/am_main/synonyms/pck_params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/pck_params.sql:null:946e6f3a7d41b3b5905b339ebdff5aec2022fefe:create

create or replace editionable synonym am_main.pck_params for core.pck_params;

