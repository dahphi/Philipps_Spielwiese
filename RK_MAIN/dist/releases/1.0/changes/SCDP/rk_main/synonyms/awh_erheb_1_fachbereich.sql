-- liquibase formatted sql
-- changeset RK_MAIN:1774561694458 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_erheb_1_fachbereich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_erheb_1_fachbereich.sql:null:b182cd69265ec54d01ab879a0d5bfefb0aa8f8f5:create

create or replace editionable synonym rk_main.awh_erheb_1_fachbereich for awh_main.v_isr_awh_erheb_1_fachbereich;

