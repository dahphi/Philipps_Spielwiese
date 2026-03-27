-- liquibase formatted sql
-- changeset AM_MAIN:1774600123008 stripComments:false logicalFilePath:am_main/am_main/synonyms/pck_logs.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/pck_logs.sql:null:8007d70b050397d00839aa5a1b2fe55c2d036642:create

create or replace editionable synonym am_main.pck_logs for core.pck_logs;

