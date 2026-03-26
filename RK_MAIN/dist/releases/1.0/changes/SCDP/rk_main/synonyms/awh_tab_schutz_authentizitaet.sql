-- liquibase formatted sql
-- changeset RK_MAIN:1774554920929 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_schutz_authentizitaet.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_schutz_authentizitaet.sql:null:5a62098de886430f4683b99b0ba35689d6441bba:create

create or replace editionable synonym rk_main.awh_tab_schutz_authentizitaet for awh_main.v_isr_awh_tab_schutz_authentizitaet;

