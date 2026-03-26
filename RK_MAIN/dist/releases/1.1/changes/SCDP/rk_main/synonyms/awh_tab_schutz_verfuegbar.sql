-- liquibase formatted sql
-- changeset RK_MAIN:1774555712999 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_schutz_verfuegbar.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_schutz_verfuegbar.sql:null:b848bf4cbf1c535aaca5730519076a81db264c8a:create

create or replace editionable synonym rk_main.awh_tab_schutz_verfuegbar for awh_main.v_isr_awh_tab_schutz_verfuegbar;

