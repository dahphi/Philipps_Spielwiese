-- liquibase formatted sql
-- changeset RK_MAIN:1774561690711 stripComments:false logicalFilePath:SCDP/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/object_grants/object_grants_as_grantor.rk_main.table.isr_oam_risikosteuerung.sql:null:eb90c2edcc95ebf4867e6a380d91d0f740d4a9d0:create

grant read on rk_main.isr_oam_risikosteuerung to awh_read_jira;

grant select on rk_main.isr_oam_risikosteuerung to rk_apex;

grant read on rk_main.isr_oam_risikosteuerung to rk_read;

