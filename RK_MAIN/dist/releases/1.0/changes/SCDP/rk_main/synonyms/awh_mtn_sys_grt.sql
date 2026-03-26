-- liquibase formatted sql
-- changeset RK_MAIN:1774561694488 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_mtn_sys_grt.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_mtn_sys_grt.sql:null:7fc018f46be6a9f7548c709292e9985c638ff404:create

create or replace editionable synonym rk_main.awh_mtn_sys_grt for awh_main.v_isr_awh_mtn_sys_grt;

