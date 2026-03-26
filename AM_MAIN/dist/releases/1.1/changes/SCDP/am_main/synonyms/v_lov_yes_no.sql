-- liquibase formatted sql
-- changeset AM_MAIN:1774557120664 stripComments:false logicalFilePath:SCDP/am_main/synonyms/v_lov_yes_no.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_lov_yes_no.sql:null:21ea1f5f4ff387659af4fb2edf4e833af21b8571:create

create or replace editionable synonym am_main.v_lov_yes_no for core.v_lov_yes_no;

