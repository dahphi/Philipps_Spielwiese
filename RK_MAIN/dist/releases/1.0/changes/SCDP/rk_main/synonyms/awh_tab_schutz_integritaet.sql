-- liquibase formatted sql
-- changeset RK_MAIN:1774561694527 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_schutz_integritaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_schutz_integritaet.sql:null:7bb91e59c4fa504cf67d8495fb23b9c30be65d5c:create

create or replace editionable synonym rk_main.awh_tab_schutz_integritaet for awh_main.v_isr_awh_tab_schutz_integritaet;

