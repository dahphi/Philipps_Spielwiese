-- liquibase formatted sql
-- changeset RK_MAIN:1774554920900 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_mtn_sys_gvb.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_mtn_sys_gvb.sql:null:3575dc18b963c3da333681359b286cf67efc0310:create

create or replace editionable synonym rk_main.awh_mtn_sys_gvb for awh_main.v_isr_awh_mtn_sys_gvb;

