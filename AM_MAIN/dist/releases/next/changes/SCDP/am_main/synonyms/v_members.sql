-- liquibase formatted sql
-- changeset AM_MAIN:1774557120670 stripComments:false logicalFilePath:SCDP/am_main/synonyms/v_members.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/v_members.sql:null:02f699a3cdd89a45b34630cd9e24d2309b9b5c1f:create

create or replace editionable synonym am_main.v_members for core.v_members;

