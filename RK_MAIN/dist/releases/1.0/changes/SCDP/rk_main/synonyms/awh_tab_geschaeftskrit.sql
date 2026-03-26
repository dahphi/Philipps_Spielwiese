-- liquibase formatted sql
-- changeset RK_MAIN:1774554920918 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_geschaeftskrit.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_geschaeftskrit.sql:null:e56340170f69b3836061b59fcfa54297ff085089:create

create or replace editionable synonym rk_main.awh_tab_geschaeftskrit for awh_main.v_isr_awh_tab_geschaeftskrit;

