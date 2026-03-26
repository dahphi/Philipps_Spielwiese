-- liquibase formatted sql
-- changeset RK_MAIN:1774554920876 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_infosec_anlagenkat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_infosec_anlagenkat.sql:null:0a425e9f083d73b7b8e009c14139d74f2adef903:create

create or replace editionable synonym rk_main.awh_infosec_anlagenkat for awh_main.v_isr_awh_infosec_anlagenkat;

