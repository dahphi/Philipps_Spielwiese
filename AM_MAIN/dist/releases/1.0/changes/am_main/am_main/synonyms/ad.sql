-- liquibase formatted sql
-- changeset AM_MAIN:1774600122863 stripComments:false logicalFilePath:am_main/am_main/synonyms/ad.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/synonyms/ad.sql:null:9d197eba679e5a63343260b556db43926c5a57d8:create

create or replace editionable synonym am_main.ad for core.ad;

