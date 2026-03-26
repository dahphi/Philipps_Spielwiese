-- liquibase formatted sql
-- changeset RK_MAIN:1774555709279 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql:null:a47f8a3f1cf6f5550ea7f2f75fa4831d75025617:create

grant select on rk_main.isr_oam_risikosteuerung to rk_apex;

grant read on rk_main.isr_oam_risikosteuerung to awh_read_jira;

grant read on rk_main.isr_oam_risikosteuerung to rk_read;

