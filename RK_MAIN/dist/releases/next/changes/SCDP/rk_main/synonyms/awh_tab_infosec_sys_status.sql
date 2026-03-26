-- liquibase formatted sql
-- changeset RK_MAIN:1774561694516 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_tab_infosec_sys_status.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_tab_infosec_sys_status.sql:null:4468cc80c664567addc42346ac537c2aade9d056:create

create or replace editionable synonym rk_main.awh_tab_infosec_sys_status for awh_main.v_isr_awh_tab_infosec_sys_status;

