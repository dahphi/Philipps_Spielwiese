-- liquibase formatted sql
-- changeset RK_MAIN:1774555712970 stripComments:false logicalFilePath:SCDP/rk_main/synonyms/awh_system.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/synonyms/awh_system.sql:null:73cfee7c62967b0d37a006122f0cdd394f809301:create

create or replace editionable synonym rk_main.awh_system for awh_main.v_isr_awh_system;

