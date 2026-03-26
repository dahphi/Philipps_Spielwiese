-- liquibase formatted sql
-- changeset RK_MAIN:1774555712947 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_infosec_sysverbindung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_infosec_sysverbindung.sql:null:d4b2911d4656d49e94fcc483ba3c700dd7acbc75:create

create or replace editionable synonym rk_main.awh_infosec_sysverbindung for awh_main.v_isr_awh_infosec_sysverbindung;

