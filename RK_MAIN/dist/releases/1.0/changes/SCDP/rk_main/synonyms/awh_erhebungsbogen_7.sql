-- liquibase formatted sql
-- changeset RK_MAIN:1774561694464 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_erhebungsbogen_7.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_erhebungsbogen_7.sql:null:a5a406c49b573860e1d52fe0b787644d14f00e99:create

create or replace editionable synonym rk_main.awh_erhebungsbogen_7 for awh_main.v_isr_awh_erhebungsbogen_7;

