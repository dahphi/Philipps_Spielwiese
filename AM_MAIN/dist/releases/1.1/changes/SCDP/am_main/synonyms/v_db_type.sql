-- liquibase formatted sql
-- changeset AM_MAIN:1774557120646 stripComments:false logicalFilePath:SCDP/am_main/synonyms/v_db_type.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_db_type.sql:null:9cabe03d864ff42c9c0c4d3fd9d8551fff3e94cf:create

create or replace editionable synonym am_main.v_db_type for core.v_db_type;

