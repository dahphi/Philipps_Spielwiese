-- liquibase formatted sql
-- changeset RK_MAIN:1774561694539 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_schutz_vertraulich.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_schutz_vertraulich.sql:null:1dfd1be365ce6ae4a38bf021a12bb6c465dbae5a:create

create or replace editionable synonym rk_main.awh_tab_schutz_vertraulich for awh_main.v_isr_awh_tab_schutz_vertraulich;

