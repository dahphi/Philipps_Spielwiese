-- liquibase formatted sql
-- changeset AM_MAIN:1774600123277 stripComments:false logicalFilePath:am_main/am_main/synonyms/v_params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_params.sql:null:f1e5863e46af6ca845eca1353804bcee260a8914:create

create or replace editionable synonym am_main.v_params for core.v_params;

