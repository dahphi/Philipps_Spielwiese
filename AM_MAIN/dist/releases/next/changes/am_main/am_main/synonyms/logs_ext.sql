-- liquibase formatted sql
-- changeset AM_MAIN:1774600122907 stripComments:false logicalFilePath:am_main/am_main/synonyms/logs_ext.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/logs_ext.sql:null:6324955bffcc7cb1b10c41db98d9da1f488adab5:create

create or replace editionable synonym am_main.logs_ext for core.logs_ext;

