-- liquibase formatted sql
-- changeset AM_MAIN:1774600122925 stripComments:false logicalFilePath:am_main/am_main/synonyms/params.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/params.sql:null:ff672a86aac9842709fc03f4c12940b9588b1d63:create

create or replace editionable synonym am_main.params for core.params;

