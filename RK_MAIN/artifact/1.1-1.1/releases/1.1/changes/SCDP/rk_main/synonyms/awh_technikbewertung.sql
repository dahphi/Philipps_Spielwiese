-- liquibase formatted sql
-- changeset RK_MAIN:1774555713010 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_technikbewertung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_technikbewertung.sql:null:a429c5c864eb69a499f3cb1611f0e924c3f5991c:create

create or replace editionable synonym rk_main.awh_technikbewertung for awh_main.v_isr_awh_technikbewertung;

