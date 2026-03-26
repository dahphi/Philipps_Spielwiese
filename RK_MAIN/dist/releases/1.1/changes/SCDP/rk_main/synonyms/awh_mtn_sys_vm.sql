-- liquibase formatted sql
-- changeset RK_MAIN:1774555712964 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_mtn_sys_vm.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_mtn_sys_vm.sql:null:8a8218a6b1b46e0f92978a10af336e975b2689c1:create

create or replace editionable synonym rk_main.awh_mtn_sys_vm for awh_main.v_isr_awh_mtn_sys_vm;

