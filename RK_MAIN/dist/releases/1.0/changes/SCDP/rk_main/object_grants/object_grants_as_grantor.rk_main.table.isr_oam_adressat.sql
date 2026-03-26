-- liquibase formatted sql
-- changeset RK_MAIN:1774554916848 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_adressat.sql:null:0461ad6728042c5cb1a7029f8e1bce0dacb2ff15:create

grant select on rk_main.isr_oam_adressat to rk_apex;

grant read on rk_main.isr_oam_adressat to rk_read;

grant read on rk_main.isr_oam_adressat to awh_read_jira;

