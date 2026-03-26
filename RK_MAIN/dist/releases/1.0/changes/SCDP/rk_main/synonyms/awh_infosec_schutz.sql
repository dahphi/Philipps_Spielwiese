-- liquibase formatted sql
-- changeset RK_MAIN:1774561694475 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_infosec_schutz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_infosec_schutz.sql:null:50975758ab5c41b8ebc1bc4a2f310f1dd00ea4e4:create

create or replace editionable synonym rk_main.awh_infosec_schutz for awh_main.v_isr_awh_infosec_schutz;

